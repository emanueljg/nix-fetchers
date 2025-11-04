{
  fetchFromGofile,
}:
{
  simple = fetchFromGofile {
    item = "https://gofile.io/d/s99zDV";
    hash = "sha256-WkHberFGLw7CjXQVtqy36v0jjqdsdpoiKAgfp9VCMig=";
  };
  one = fetchFromGofile {
    item = "https://gofile.io/d/s99zDV";
    select.one = "How To Make Wargames Terrain_2003.pdf";
    # hash = "sha256-myIzsfDZhDoDFKt41Y2fcHOBhHg/svt6I7YSEp2Q19o=";
  };
  manyWithOne = fetchFromGofile {
    item = "https://gofile.io/d/vdl4tk";
    select.many = [
      "Witch_Hunters.odt"
    ];
    hash = "sha256-wpMq3hjPDdvEZKP1s2aLNqDuc/T+U1pRTElRTfCy0HU=";
  };
  manyWithMany = fetchFromGofile {
    item = "https://gofile.io/d/vdl4tk";
    select.many = [
      "Witch_Hunters.odt"
      "Witch_Hunters.pdf"
    ];
  };
  manyWithMissing = fetchFromGofile {
    item = "https://gofile.io/d/vdl4tk";
    select.many = [
      "Witch_Hunters.odt"
      "does-not-exist"
    ];
  };
  manyWithEmpty = fetchFromGofile {
    item = "https://gofile.io/d/vdl4tk";
    select.many = [ ];
  };
  manyWithDupes = fetchFromGofile {
    item = "https://gofile.io/d/vdl4tk";
    select.many = [
      "foo"
      "foo"
    ];
  };
}
