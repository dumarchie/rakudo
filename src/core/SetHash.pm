my class SetHash does Setty {

    method ISINSET(\key) {
        Proxy.new(
          FETCH => { %!elems.EXISTS-KEY(key) },
          STORE => -> $, \value {
              %!elems.DELETE-KEY(key) unless value;
              value;
          }
        );
    }

    method !SET-SELF(%!elems) { self }
    method Set(SetHash:D: :$view) {
        $view
          ?? nqp::p6bindattrinvres(nqp::create(Set),Set,'%!elems',%!elems)
          !! Set.new(self.keys)
    }
    method SetHash(SetHash:D:) { self }

    multi method AT-KEY(SetHash:D: \k --> Bool) is raw {
        Proxy.new(
          FETCH => {
              %!elems.EXISTS-KEY(k.WHICH);
          },
          STORE => -> $, $value {
              $value
                ?? %!elems.ASSIGN-KEY(k.WHICH,k)
                !! %!elems.DELETE-KEY(k.WHICH);
              so $value;
          });
    }
    multi method DELETE-KEY(SetHash:D: \k --> Bool) {
        my $key := k.WHICH;
        return False unless %!elems.EXISTS-KEY($key);

        %!elems.DELETE-KEY($key);
        True;
    }
}

# vim: ft=perl6 expandtab sw=4
