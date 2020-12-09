import 'js-autocomplete/auto-complete.css';
import autocomplete from 'js-autocomplete';

const autocompleteSearch = function() {
  const communities = JSON.parse(document.getElementById('search-data').dataset.communities_auto)
  const searchInput = document.getElementById('query');

  if (communities && searchInput) {
    new autocomplete({
      selector: searchInput,
      minChars: 1,
      source: function(term, suggest){
          term = term.toLowerCase();
          const choices = communities;
          const matches = [];
          for (let i = 0; i < choices.length; i++)
              if (~choices[i].toLowerCase().indexOf(term)) matches.push(choices[i]);
          suggest(matches);
      },
      onSelect: autocompleteSearch
    });
  }
};

export { autocompleteSearch };
