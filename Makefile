TARGET = ANALIZADOR
CXX = g++
FLEX = flex++

all: $(TARGET)

$(TARGET): lex.yy.cc
	$(CXX) lex.yy.cc -o $(TARGET)

lex.yy.cc: analizador.l
	$(FLEX) analizador.l

clean:
	rm -f $(TARGET) lex.yy.cc data.html

run: $(TARGET)
	./$(TARGET)
