package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.TileOverlay;
import com.google.android.gms.maps.model.TileOverlayOptions;
import com.google.maps.android.heatmaps.HeatmapTileProvider;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HeatmapsController {
    private final Map<String, HeatmapController> heatmapIdToController;
    private GoogleMap googleMap;

    HeatmapsController() {
        this.heatmapIdToController = new HashMap<>();
    }

    void setGoogleMap(GoogleMap googleMap) {
        this.googleMap = googleMap;
    }

    void addHeatmaps(List<Object> heatmapsToAdd) {
        if (heatmapsToAdd == null) {
            return;
        }
        for (Object heatmapToAdd : heatmapsToAdd) {
            addHeatmap(heatmapToAdd);
        }
    }

    void changeHeatmaps(List<Object> heatmapsToChange) {
        if (heatmapsToChange == null) {
            return;
        }
        for (Object heatmapToChange : heatmapsToChange) {
            changeHeatmap(heatmapToChange);
        }
    }

    void removeHeatmaps(List<Object> heatmapIdsToRemove) {
        if (heatmapIdsToRemove == null) {
            return;
        }
        for (Object rawHeatmapId : heatmapIdsToRemove) {
            if (rawHeatmapId == null) {
                continue;
            }
            String heatmapId = (String) rawHeatmapId;
            final HeatmapController heatmapController = heatmapIdToController.remove(heatmapId);
            if (heatmapController != null) {
                heatmapController.remove();
            }
        }
    }

    private void addHeatmap(Object heatmapOptions) {
        if (heatmapOptions == null) {
            return;
        }
        HeatmapBuilder heatmapBuilder = new HeatmapBuilder();
        String heatmapId =
                Convert.interpretHeatmapOptions(heatmapOptions, heatmapBuilder);

        HeatmapTileProvider heatmap = heatmapBuilder.build();
        TileOverlay heatmapTileOverlay = googleMap.addTileOverlay(new TileOverlayOptions().tileProvider(heatmap));
        HeatmapController heatmapController = new HeatmapController(heatmap, heatmapTileOverlay);
        heatmapIdToController.put(heatmapId, heatmapController);
    }

    private void changeHeatmap(Object heatmapOptions) {
        if (heatmapOptions == null) {
            return;
        }
        String heatmapId = getHeatmapId(heatmapOptions);
        HeatmapController heatmapController = heatmapIdToController.get(heatmapId);
        if (heatmapController != null) {
            Convert.interpretHeatmapOptions(heatmapOptions, heatmapController);
            heatmapController.clearTileCache();
        }
    }

    private void removeHeatmap(String heatmapId) {
        HeatmapController heatmapController = heatmapIdToController.get(heatmapId);
        if (heatmapController != null) {
            heatmapController.remove();
            heatmapIdToController.remove(heatmapId);
        }
    }

    @SuppressWarnings("unchecked")
    private static String getHeatmapId(Object heatmap) {
        Map<String, Object> heatmapMap = (Map<String, Object>) heatmap;
        return (String) heatmapMap.get("heatmapId");
    }
}
