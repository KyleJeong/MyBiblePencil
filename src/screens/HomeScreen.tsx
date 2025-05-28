import React, { useState, useEffect } from 'react';
import { StyleSheet, View, Text, TouchableOpacity, useWindowDimensions, SafeAreaView, Platform, Dimensions } from 'react-native';
import Canvas from '../components/Canvas';

const HomeScreen = () => {
  const [strokeWidth, setStrokeWidth] = useState(2);
  const [strokeColor, setStrokeColor] = useState('#000000');
  const [dimensions, setDimensions] = useState({
    width: Dimensions.get('window').width,
    height: Dimensions.get('window').height,
  });

  useEffect(() => {
    const subscription = Dimensions.addEventListener('change', ({ window }) => {
      setDimensions({
        width: window.width,
        height: window.height,
      });
    });

    return () => subscription?.remove();
  }, []);

  const isLandscape = dimensions.width > dimensions.height;
  const headerHeight = Platform.OS === 'ios' ? 80 : 60;
  const toolbarHeight = Platform.OS === 'ios' ? 100 : 80;
  const availableHeight = dimensions.height - headerHeight - toolbarHeight;
  
  const textWidth = isLandscape ? dimensions.width * 0.3 : dimensions.width * 0.4;
  const canvasWidth = dimensions.width - textWidth;
  const canvasHeight = availableHeight;

  return (
    <SafeAreaView style={[styles.safeArea, { height: dimensions.height }]}>
      <View style={[styles.container, { height: dimensions.height }]}>
        <View style={[styles.header, { height: headerHeight }]}>
          <Text style={styles.title}>성경 필사</Text>
        </View>
        
        <View style={[styles.mainContent, { height: availableHeight }]}>
          <View style={[styles.textContainer, { width: textWidth }]}>
            <Text style={styles.bibleText}>
              태초에 하나님이 천지를 창조하시니라{'\n\n'}
              땅이 혼돈하고 공허하며 흑암이 깊음 위에 있고 하나님의 영은 수면 위에 운행하시니라{'\n\n'}
              하나님이 이르시되 빛이 있으라 하시니 빛이 있었고{'\n\n'}
              빛이 하나님이 보시기에 좋았더라 하나님이 빛과 어둠을 나누사{'\n\n'}
              하나님이 빛을 낮이라 부르시고 어둠을 밤이라 부르시니라 저녁이 되고 아침이 되니 이는 첫째 날이니라
            </Text>
          </View>
          
          <View style={[styles.canvasContainer, { width: canvasWidth, height: canvasHeight }]}>
            <Canvas 
              strokeWidth={strokeWidth} 
              strokeColor={strokeColor}
              width={canvasWidth}
              height={canvasHeight}
            />
          </View>
        </View>

        <View style={[styles.toolbar, { height: toolbarHeight }]}>
          <TouchableOpacity
            style={[styles.toolButton, { backgroundColor: '#000000' }]}
            onPress={() => setStrokeColor('#000000')}
          />
          <TouchableOpacity
            style={[styles.toolButton, { backgroundColor: '#FF0000' }]}
            onPress={() => setStrokeColor('#FF0000')}
          />
          <TouchableOpacity
            style={[styles.toolButton, { backgroundColor: '#0000FF' }]}
            onPress={() => setStrokeColor('#0000FF')}
          />
          <TouchableOpacity
            style={styles.toolButton}
            onPress={() => setStrokeWidth(prev => Math.min(prev + 1, 10))}
          >
            <Text style={styles.toolButtonText}>+</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.toolButton}
            onPress={() => setStrokeWidth(prev => Math.max(prev - 1, 1))}
          >
            <Text style={styles.toolButtonText}>-</Text>
          </TouchableOpacity>
        </View>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#fff',
  },
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
    justifyContent: 'center',
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  mainContent: {
    flexDirection: 'row',
  },
  textContainer: {
    padding: 20,
    borderRightWidth: 1,
    borderRightColor: '#eee',
  },
  bibleText: {
    fontSize: 18,
    lineHeight: 28,
  },
  canvasContainer: {
    backgroundColor: '#fff',
  },
  toolbar: {
    flexDirection: 'row',
    padding: 10,
    borderTopWidth: 1,
    borderTopColor: '#eee',
    justifyContent: 'space-around',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  toolButton: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: '#eee',
    justifyContent: 'center',
    alignItems: 'center',
  },
  toolButtonText: {
    fontSize: 24,
    fontWeight: 'bold',
  },
});

export default HomeScreen; 