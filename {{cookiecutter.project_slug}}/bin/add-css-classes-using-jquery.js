(() => {
    function myfun(debug_only, css_query, start_idx, end_idx, klass) {
        function ac(el) {
            el.addClass(klass);
        }
        // return;
        let elems = $(css_query);
        elems = elems.slice(start_idx, end_idx);
        console.log(elems.length, elems, elems.find("> *"));
        if (debug_only) {
            return;
        }
        console.log(
            ac(
                elems
                    .filter((i, x) => {
                        return !$(x).hasClass("jqtree_common");
                    })
                    .find("*"),
            ),
        );
        ac($(css_query));
    }
    myfun(0, "div#container-all > *", 0, 1);
})();
