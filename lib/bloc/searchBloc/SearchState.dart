import '../../moduls/details_for_individual.dart'; // Update to correct file structure

abstract class SearchState {}

class InitSearchState extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResultsLoaded extends SearchState {
  final List<Details> searchResults;
  SearchResultsLoaded(this.searchResults);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
