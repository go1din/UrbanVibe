import 'package:flutter/material.dart';
import 'search_page_list.dart';
import 'search_page_map.dart';
import 'bing_search_service.dart';
import 'package:location/location.dart';

class SearchPage extends StatefulWidget {
  final Map<String, String> selectedOptions;

  SearchPage({required this.selectedOptions});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BingSearchService _bingSearchService = BingSearchService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _events = [];
  bool _isLoading = false;
  LocationData? _currentLocation;
  late Location _location;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _location = Location();
    _getLocation();
    _location.changeSettings(
        distanceFilter: 50); // Set the distance filter to 50 meters
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
        if (_events.isEmpty) {
          _search();
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabItemTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void _search() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final query = _controller.text.isEmpty && _currentLocation != null
          ? '${_currentLocation!.latitude},${_currentLocation!.longitude}'
          : _controller.text;
      final events =
          await _bingSearchService.search(query, widget.selectedOptions);
      setState(() {
        _events = events;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await _location.getLocation();
    setState(() {
      _isLoading = false;
      if (_events.isEmpty) {
        _search();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UrbanVibe App'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Column(
            children: [
              Text(
                'My Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: _isLoading
                    ? Text('GPS')
                    : _currentLocation != null
                        ? Text(
                            'Latitude: ${_currentLocation!.latitude}, Longitude: ${_currentLocation!.longitude}')
                        : Text('Failed to get location'),
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'List'),
                  Tab(text: 'Map'),
                ],
                onTap: _onTabItemTapped,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SearchPageList(
            controller: _controller,
            events: _events,
            isLoading: _isLoading,
            onSearch: _search,
          ),
          SearchPageMap(events: _events),
        ],
      ),
    );
  }
}
