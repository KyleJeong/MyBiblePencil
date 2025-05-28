import React, { useCallback, useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { PanGestureHandler, GestureHandlerRootView } from 'react-native-gesture-handler';
import Animated, {
  useAnimatedGestureHandler,
  useAnimatedStyle,
  useSharedValue,
} from 'react-native-reanimated';
import Svg, { Path } from 'react-native-svg';

interface Point {
  x: number;
  y: number;
}

interface CanvasProps {
  strokeWidth?: number;
  strokeColor?: string;
  width?: number;
  height?: number;
}

const Canvas: React.FC<CanvasProps> = ({
  strokeWidth = 2,
  strokeColor = '#000000',
  width,
  height,
}) => {
  const [paths, setPaths] = useState<Point[][]>([]);
  const [currentPath, setCurrentPath] = useState<Point[]>([]);

  const translateX = useSharedValue(0);
  const translateY = useSharedValue(0);

  const gestureHandler = useAnimatedGestureHandler({
    onStart: (event, ctx: any) => {
      ctx.startX = translateX.value;
      ctx.startY = translateY.value;
      const { x, y } = event;
      setCurrentPath([{ x, y }]);
    },
    onActive: (event, ctx) => {
      translateX.value = ctx.startX + event.translationX;
      translateY.value = ctx.startY + event.translationY;
      const { x, y } = event;
      setCurrentPath(prev => [...prev, { x, y }]);
    },
    onEnd: () => {
      if (currentPath.length > 0) {
        setPaths(prev => [...prev, currentPath]);
        setCurrentPath([]);
      }
    },
  });

  const animatedStyle = useAnimatedStyle(() => {
    return {
      transform: [
        { translateX: translateX.value },
        { translateY: translateY.value },
      ],
    };
  });

  const renderPath = (points: Point[]) => {
    if (points.length < 2) return null;

    const d = points.reduce((acc, point, index) => {
      if (index === 0) return `M ${point.x} ${point.y}`;
      return `${acc} L ${point.x} ${point.y}`;
    }, '');

    return (
      <Path
        d={d}
        stroke={strokeColor}
        strokeWidth={strokeWidth}
        fill="none"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    );
  };

  return (
    <GestureHandlerRootView style={[styles.container, { width, height }]}>
      <PanGestureHandler onGestureEvent={gestureHandler}>
        <Animated.View style={[styles.canvas, animatedStyle, { width, height }]}>
          <Svg style={StyleSheet.absoluteFill}>
            {paths.map((path, index) => (
              <React.Fragment key={index}>
                {renderPath(path)}
              </React.Fragment>
            ))}
            {renderPath(currentPath)}
          </Svg>
        </Animated.View>
      </PanGestureHandler>
    </GestureHandlerRootView>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#fff',
  },
  canvas: {
    backgroundColor: '#fff',
  },
});

export default Canvas; 