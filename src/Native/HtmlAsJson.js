var _eeue56$elm_html_test$Native_HtmlAsJson = (function() {
    function forceThunks(vNode) {
        if (typeof vNode !== 'undefined' && vNode.type === 'thunk' && !vNode.node) {
            vNode.node = vNode.thunk.apply(vNode.thunk, vNode.args);
        }
        if (typeof vNode !== 'undefined' && typeof vNode.children !== 'undefined') {
            vNode.children = vNode.children.map(forceThunks);
        }
        return vNode;
    }

    return {
        toJson: function(html) {
            return forceThunks(html);
        },
        eventDecoder: function (event) {
            return event.decoder;
        },
        taggerFunction: function (tagger) {
            return tagger;
        },
        attributeName: function(attribute) {
          switch (attribute.key) {
            case 'STYLE':
              return 'style';

            case 'EVENT':
            case 'ATTR':
            case 'ATTR_NS':
              return attribute.realKey;

            default:
              return attribute.key;
          }
        }
    };
})();
