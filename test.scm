(use missbehave missbehave-matchers missbehave-stubs miscmacros)

(use path)
(use posix)

(describe "Path module"
  (it "must be able to split paths into (head, tail)"
      (expect (split "") (be (list "" "")))
      (expect (split "..") (be (list "" "..")))
      (expect (split ".a.") (be (list "" ".a.")))
      (expect (split ".a..") (be (list "" ".a..")))
      (expect (split "a.a..") (be (list "" "a.a..")))
      (expect (split "a/a.a..") (be (list "a" "a.a..")))
      (expect (split "/a/a.a..") (be (list "/a" "a.a..")))
      (expect (split "/b/a/a.a..") (be (list "/b/a" "a.a..")))

      (expect (split "///") (be (list "///" "")))
      (expect (split "//a//b//") (be (list "//a//b" "")))
      (expect (split "//a//b//c") (be (list "//a//b" "c")))

      (expect (split "a") (be (list "" "a")))
      (expect (split "a/b/c") (be (list "a/b" "c"))))

  (it "must be able to find a basename"
      (expect (basename "a") (be "a"))
      (expect (basename "a/b") (be "b"))
      (expect (basename "a/b/") (be ""))
      (expect (basename "a/b//") (be ""))
      (expect (basename "..") (be ".."))
      (expect (basename ".") (be "."))
      (expect (basename "../..") (be ".."))
      (expect (basename "aa/bb/cc/d.t") (be "d.t"))
      (expect (basename "a.text/b.txt/c") (be "c")))

  (it "must be able to find a dirname"
      (expect (dirname "a") (be ""))
      (expect (dirname "a/b") (be "a"))
      (expect (dirname "a/b/") (be "a/b"))
      (expect (dirname "a/b//") (be "a/b"))
      (expect (dirname "..") (be ""))
      (expect (dirname ".") (be ""))
      (expect (dirname "../..") (be ".."))
      (expect (dirname "aa/bb/cc/d.t") (be "aa/bb/cc"))
      (expect (dirname "a.text/b.txt/c") (be "a.text/b.txt")))

  (it "must be able to test if a file exists"
      (expect (exists? ".") (be #t))
      (expect (exists? "..") (be #t))
      (expect (exists? "/") (be #t))
      (expect (exists? "/..") (be #t))
      (expect (exists? "/../..") (be #t))
      (expect (exists? "test.scm") (be #t))
      (expect (exists? "./path.scm") (be #t))
      (expect (exists? "./path.scm/") (be #f))
      (expect (exists? "././path.scm") (be #t))
      (expect (exists? "foobar") (be #f)))

  (it "must be able to join paths"
      (expect (join "." "c" ".") (be "./c/."))
      (expect (join "." "." "c") (be "././c"))
      (expect (join "." ".." "c") (be "./../c"))
      (expect (join ".." "a/b" "c") (be "../a/b/c"))
      (expect (join "a" "a/b" "c/") (be "a/a/b/c/"))
      (expect (join "a" "b" "c") (be "a/b/c")))

  (it "must be able to normalize a path"
      (expect (normpath "") (be "."))
      (expect (normpath ".") (be "."))
      (expect (normpath "a/..") (be "."))
      (expect (normpath "a/b/../..") (be "."))
      (expect (normpath "a/b/../") (be "a"))
      (expect (normpath "./a/b/../") (be "a"))
      (expect (normpath "..") (be ".."))
      (expect (normpath "../..") (be "../.."))
      (expect (normpath "../../") (be "../.."))
      (expect (normpath "/../../") (be "/"))
      (expect (normpath "./../../") (be "../.."))
      (expect (normpath "././../../") (be "../.."))
      (expect (normpath "././../a/../") (be ".."))
      (expect (normpath "././../a/b/../") (be "../a"))
      (expect (normpath "././../b/a/../") (be "../b"))
      (expect (normpath "/././../b/a/../") (be "/b"))
      ;(expect (normpath "//a/b") (be "//a/b"))
      ;(expect (normpath "//a/..//a") (be "//a"))
      ;(expect (normpath "//a/..///a") (be "//a"))
      ;(expect (normpath "///a/b") (be "/a/b"))
      )

  (it "must be able to give an absolute path"
      (expect (abspath "a/b") (be (join (current-directory) "a/b")))
      (expect (abspath "./a/b") (be (join (current-directory) "a/b")))
      (expect (abspath "/a/b") (be "/a/b")))
)

