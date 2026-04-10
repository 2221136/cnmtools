import '../models/personality_test_model.dart';
import '../data/personality_types_data.dart';

class PersonalityTestService {
  static final Map<String, DimensionMeta> dimensionMeta = {
    'S1': DimensionMeta(name: 'S1 自尊自信', model: '自我模型'),
    'S2': DimensionMeta(name: 'S2 自我清晰度', model: '自我模型'),
    'S3': DimensionMeta(name: 'S3 核心价值', model: '自我模型'),
    'E1': DimensionMeta(name: 'E1 依恋安全感', model: '情感模型'),
    'E2': DimensionMeta(name: 'E2 情感投入度', model: '情感模型'),
    'E3': DimensionMeta(name: 'E3 边界与依赖', model: '情感模型'),
    'A1': DimensionMeta(name: 'A1 世界观倾向', model: '态度模型'),
    'A2': DimensionMeta(name: 'A2 规则与灵活度', model: '态度模型'),
    'A3': DimensionMeta(name: 'A3 人生意义感', model: '态度模型'),
    'Ac1': DimensionMeta(name: 'Ac1 动机导向', model: '行动驱力模型'),
    'Ac2': DimensionMeta(name: 'Ac2 决策风格', model: '行动驱力模型'),
    'Ac3': DimensionMeta(name: 'Ac3 执行模式', model: '行动驱力模型'),
    'So1': DimensionMeta(name: 'So1 社交主动性', model: '社交模型'),
    'So2': DimensionMeta(name: 'So2 人际边界感', model: '社交模型'),
    'So3': DimensionMeta(name: 'So3 表达与真实度', model: '社交模型'),
  };

  static List<PersonalityQuestion> getQuestions() {
    return [
      PersonalityQuestion(
        id: 'q1',
        dimension: 'S1',
        text: '我不仅是屌丝，我还是joker,我还是咸鱼，这辈子没谈过一场恋爱，胆怯又自卑，我的青春就是一场又一场的意淫，每一天幻想着我也能有一个女孩子和我一起压马路，一起逛街，一起玩，现实却是爆了父母金币，读了个烂学校，混日子之后找班上，没有理想，没有目标，没有能力的三无人员，每次看到你能在网上开屌丝的玩笑，我都想哭，我就是地底下的老鼠，透过下水井的缝隙，窥探地上的各种美好，每一次看到这种都是对我心灵的一次伤害，对我生存空间的一次压缩，求求哥们给我们这种小丑一点活路吧，我真的不想在白天把枕巾哭湿一大片',
        options: [
          QuestionOption(label: '我哭了。。', value: 1),
          QuestionOption(label: '这是什么。。', value: 2),
          QuestionOption(label: '这不是我！', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q2',
        dimension: 'S1',
        text: '我不够好，周围的人都比我优秀',
        options: [
          QuestionOption(label: '确实', value: 1),
          QuestionOption(label: '有时', value: 2),
          QuestionOption(label: '不是', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q3',
        dimension: 'S2',
        text: '我很清楚真正的自己是什么样的',
        options: [
          QuestionOption(label: '不认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q4',
        dimension: 'S2',
        text: '我内心有真正追求的东西',
        options: [
          QuestionOption(label: '不认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q5',
        dimension: 'S3',
        text: '我一定要不断往上爬、变得更厉害',
        options: [
          QuestionOption(label: '不认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q6',
        dimension: 'S3',
        text: '外人的评价对我来说无所吊谓。',
        options: [
          QuestionOption(label: '不认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q7',
        dimension: 'E1',
        text: '对象超过5小时没回消息，说自己窜稀了，你会怎么想？',
        options: [
          QuestionOption(label: '拉稀不可能5小时，也许ta隐瞒了我。', value: 1),
          QuestionOption(label: '在信任和怀疑之间摇摆。', value: 2),
          QuestionOption(label: '也许今天ta真的不太舒服。', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q8',
        dimension: 'E1',
        text: '我在感情里经常担心被对方抛弃',
        options: [
          QuestionOption(label: '是的', value: 1),
          QuestionOption(label: '偶尔', value: 2),
          QuestionOption(label: '不是', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q9',
        dimension: 'E2',
        text: '我对天发誓，我对待每一份感情都是认真的！',
        options: [
          QuestionOption(label: '并没有', value: 1),
          QuestionOption(label: '也许？', value: 2),
          QuestionOption(label: '是的！（问心无愧骄傲脸）', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q10',
        dimension: 'E2',
        text: '你的恋爱对象是一个尊老爱幼，温柔敦厚，洁身自好，光明磊落，大义凛然，能言善辩，口才流利，观察入微，见多识广，博学多才，诲人不倦，和蔼可亲，平易近人，心地善良，慈眉善目，积极进取，意气风发，玉树临风，国色天香，倾国倾城，花容月貌的人，此时你会？',
        options: [
          QuestionOption(label: '就算ta再优秀我也不会陷入太深。', value: 1),
          QuestionOption(label: '会介于A和C之间。', value: 2),
          QuestionOption(label: '会非常珍惜ta，也许会变成恋爱脑。', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q11',
        dimension: 'E3',
        text: '恋爱后，对象非常黏人，你作何感想？',
        options: [
          QuestionOption(label: '那很爽了', value: 1),
          QuestionOption(label: '都行无所谓', value: 2),
          QuestionOption(label: '我更喜欢保留独立空间', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q12',
        dimension: 'E3',
        text: '我在任何关系里都很重视个人空间',
        options: [
          QuestionOption(label: '我更喜欢依赖与被依赖', value: 1),
          QuestionOption(label: '看情况', value: 2),
          QuestionOption(label: '是的！（斩钉截铁地说道）', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q13',
        dimension: 'A1',
        text: '大多数人是善良的',
        options: [
          QuestionOption(label: '其实邪恶的人心比世界上的痔疮更多。', value: 1),
          QuestionOption(label: '也许吧。', value: 2),
          QuestionOption(label: '是的，我愿相信好人更多。', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q14',
        dimension: 'A1',
        text: '你走在街上，一位萌萌的小女孩蹦蹦跳跳地朝你走来（正脸、侧脸看都萌，用vivo、苹果、华为、OPPO手机看都萌，实在是非常萌的那种），她递给你一根棒棒糖，此时你作何感想？',
        options: [
          QuestionOption(label: '呜呜她真好真可爱！居然给我棒棒糖！', value: 3),
          QuestionOption(label: '一脸懵逼，作挠头状', value: 2),
          QuestionOption(label: '这也许是一种新型诈骗？还是走开为好。', value: 1),
        ],
      ),
      PersonalityQuestion(
        id: 'q15',
        dimension: 'A2',
        text: '快考试了，学校规定必须上晚自习，请假会扣分，但今晚你约了女/男神一起玩《绝地求生：刺激战场》（一款刺激的游戏），你怎么办？',
        options: [
          QuestionOption(label: '翘了！反正就一次！', value: 1),
          QuestionOption(label: '干脆请个假吧。', value: 2),
          QuestionOption(label: '都快考试了还去啥。', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q16',
        dimension: 'A2',
        text: '我喜欢打破常规，不喜欢被束缚',
        options: [
          QuestionOption(label: '认同', value: 1),
          QuestionOption(label: '保持中立', value: 2),
          QuestionOption(label: '不认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q17',
        dimension: 'A3',
        text: '我做事通常有目标。',
        options: [
          QuestionOption(label: '不认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q18',
        dimension: 'A3',
        text: '突然某一天，我意识到人生哪有什么他妈的狗屁意义，人不过是和动物一样被各种欲望支配着，纯纯是被激素控制的东西，饿了就吃，困了就睡，一发情就想交配，我们简直和猪狗一样没什么区别。',
        options: [
          QuestionOption(label: '是这样的。', value: 1),
          QuestionOption(label: '也许是，也许不是。', value: 2),
          QuestionOption(label: '这简直是胡扯', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q19',
        dimension: 'Ac1',
        text: '我做事主要为了取得成果和进步，而不是避免麻烦和风险。',
        options: [
          QuestionOption(label: '不认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q20',
        dimension: 'Ac1',
        text: '你因便秘坐在马桶上（已长达30分钟），拉不出很难受。此时你更像',
        options: [
          QuestionOption(label: '再坐三十分钟看看，说不定就有了。', value: 1),
          QuestionOption(label: '用力拍打自己的屁股并说："死屁股，快拉啊！"', value: 2),
          QuestionOption(label: '使用开塞露，快点拉出来才好。', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q21',
        dimension: 'Ac2',
        text: '我做决定比较果断，不喜欢犹豫',
        options: [
          QuestionOption(label: '不认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q22',
        dimension: 'Ac2',
        text: '此题没有题目，请盲选',
        options: [
          QuestionOption(label: '反复思考后感觉应该选A？', value: 1),
          QuestionOption(label: '啊，要不选B？', value: 2),
          QuestionOption(label: '不会就选C？', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q23',
        dimension: 'Ac3',
        text: '别人说你"执行力强"，你内心更接近哪句？',
        options: [
          QuestionOption(label: '我被逼到最后确实执行力超强。。。', value: 1),
          QuestionOption(label: '啊，有时候吧。', value: 2),
          QuestionOption(label: '是的，事情本来就该被推进', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q24',
        dimension: 'Ac3',
        text: '我做事常常有计划，____',
        options: [
          QuestionOption(label: '然而计划不如变化快。', value: 1),
          QuestionOption(label: '有时能完成，有时不能。', value: 2),
          QuestionOption(label: '我讨厌被打破计划。', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q25',
        dimension: 'So1',
        text: '你因玩《第五人格》（一款刺激的游戏）而结识许多网友，并被邀请线下见面，你的想法是？',
        options: [
          QuestionOption(label: '网上口嗨下就算了，真见面还是有点忐忑。', value: 1),
          QuestionOption(label: '见网友也挺好，反正谁来聊我就聊两句。', value: 2),
          QuestionOption(label: '我会打扮一番并热情聊天，万一呢，我是说万一呢？', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q26',
        dimension: 'So1',
        text: '朋友带了ta的朋友一起来玩，你最可能的状态是',
        options: [
          QuestionOption(label: '对"朋友的朋友"天然有点距离感，怕影响二人关系', value: 1),
          QuestionOption(label: '看对方，能玩就玩。', value: 2),
          QuestionOption(label: '朋友的朋友应该也算我的朋友！要热情聊天', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q27',
        dimension: 'So2',
        text: '我和人相处主打一个电子围栏，靠太近会自动报警。',
        options: [
          QuestionOption(label: '认同', value: 3),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '不认同', value: 1),
        ],
      ),
      PersonalityQuestion(
        id: 'q28',
        dimension: 'So2',
        text: '我渴望和我信任的人关系密切，熟得像失散多年的亲戚。',
        options: [
          QuestionOption(label: '认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '不认同', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q29',
        dimension: 'So3',
        text: '有时候你明明对一件事有不同的、负面的看法，但最后没说出来。多数情况下原因是：',
        options: [
          QuestionOption(label: '这种情况较少。', value: 1),
          QuestionOption(label: '可能碍于情面或者关系。', value: 2),
          QuestionOption(label: '不想让别人知道自己是个阴暗的人。', value: 3),
        ],
      ),
      PersonalityQuestion(
        id: 'q30',
        dimension: 'So3',
        text: '我在不同人面前会表现出不一样的自己',
        options: [
          QuestionOption(label: '不认同', value: 1),
          QuestionOption(label: '中立', value: 2),
          QuestionOption(label: '认同', value: 3),
        ],
      ),
    ];
  }

  static Map<String, PersonalityType> getPersonalityTypes() {
    return PersonalityTypesData.getAllTypes();
  }

  static TestResult calculateResult(Map<String, int> answers) {
    Map<String, int> dimensionScores = {};
    
    // 计算每个维度的得分
    for (var entry in answers.entries) {
      final question = getQuestions().firstWhere((q) => q.id == entry.key);
      final dimension = question.dimension;
      dimensionScores[dimension] = (dimensionScores[dimension] ?? 0) + entry.value;
    }

    // 基于维度得分判定人格类型
    final types = getPersonalityTypes();
    final totalScore = dimensionScores.values.reduce((a, b) => a + b);
    final avgScore = totalScore / dimensionScores.length;

    // 获取各个模型的平均分
    final s1 = dimensionScores['S1'] ?? 0;
    final s2 = dimensionScores['S2'] ?? 0;
    final s3 = dimensionScores['S3'] ?? 0;
    final e1 = dimensionScores['E1'] ?? 0;
    final e2 = dimensionScores['E2'] ?? 0;
    final e3 = dimensionScores['E3'] ?? 0;
    final a1 = dimensionScores['A1'] ?? 0;
    final a2 = dimensionScores['A2'] ?? 0;
    final a3 = dimensionScores['A3'] ?? 0;
    final ac1 = dimensionScores['Ac1'] ?? 0;
    final ac2 = dimensionScores['Ac2'] ?? 0;
    final ac3 = dimensionScores['Ac3'] ?? 0;
    final so1 = dimensionScores['So1'] ?? 0;
    final so2 = dimensionScores['So2'] ?? 0;
    final so3 = dimensionScores['So3'] ?? 0;

    final selfAvg = (s1 + s2 + s3) / 3;
    final emotionAvg = (e1 + e2 + e3) / 3;
    final attitudeAvg = (a1 + a2 + a3) / 3;
    final actionAvg = (ac1 + ac2 + ac3) / 3;
    final socialAvg = (so1 + so2 + so3) / 3;

    PersonalityType selectedType;

    // 根据不同维度组合判定人格类型
    if (selfAvg >= 2.5 && actionAvg >= 2.5 && attitudeAvg >= 2.5) {
      selectedType = types['BOSS']!; // 领导者：高自我+高行动+高态度
    } else if (selfAvg >= 2.5 && actionAvg >= 2.5) {
      selectedType = types['CTRL']!; // 拿捏者：高自我+高行动
    } else if (emotionAvg >= 2.5 && socialAvg >= 2.5) {
      selectedType = types['LOVE-R']!; // 恋爱脑：高情感+高社交
    } else if (attitudeAvg >= 2.5 && emotionAvg >= 2.5) {
      selectedType = types['THAN-K']!; // 感恩者：高态度+高情感
    } else if (socialAvg >= 2.5 && actionAvg >= 2.5) {
      selectedType = types['GOGO']!; // 冲冲人：高社交+高行动
    } else if (selfAvg >= 2.3 && so3 >= 5) {
      selectedType = types['SEXY']!; // 性感人：较高自我+高表达真实度
    } else if (emotionAvg >= 2.3 && e2 >= 5) {
      selectedType = types['MUM']!; // 妈妈人：高情感投入
    } else if (so3 <= 3 && selfAvg >= 2.0) {
      selectedType = types['FAKE']!; // 伪装者：低表达真实度+中等自我
    } else if (attitudeAvg >= 2.0 && actionAvg <= 1.8) {
      selectedType = types['THIN-K']!; // 思考者：高态度+低行动
    } else if (socialAvg >= 2.0 && so2 <= 3) {
      selectedType = types['OJBK']!; // OJBK人：高社交+低边界感
    } else if (attitudeAvg <= 1.5 && a3 <= 3) {
      selectedType = types['SHIT']!; // 愤世者：低态度+低意义感
    } else if (actionAvg <= 1.5 && ac3 <= 3) {
      selectedType = types['ZZZZ']!; // 嗜睡者：低行动+低执行
    } else if (selfAvg <= 1.5 && s1 <= 3) {
      selectedType = types['IMFW']!; // 废物：低自我+低自信
    } else if (emotionAvg <= 1.5 && e3 >= 5) {
      selectedType = types['SOLO']!; // 独行者：低情感+高边界
    } else if (socialAvg <= 1.5 && so1 <= 3) {
      selectedType = types['MONK']!; // 僧人：低社交+低主动性
    } else if (selfAvg <= 1.8 && emotionAvg <= 1.8) {
      selectedType = types['DEAD']!; // 死人：低自我+低情感
    } else if (attitudeAvg <= 1.8 && a1 <= 3) {
      selectedType = types['MALO']!; // 恶人：低态度+低世界观
    } else if (selfAvg <= 2.0 && s1 <= 4) {
      selectedType = types['Dior-s']!; // 屌丝：较低自我+较低自信
    } else if (emotionAvg <= 2.0 && e1 <= 3) {
      selectedType = types['OH-NO']!; // 哦不人：较低情感+低安全感
    } else if (socialAvg >= 2.2 && so3 >= 5) {
      selectedType = types['HHHH']!; // 哈哈人：高社交+高表达
    } else if (actionAvg >= 2.2 && ac2 <= 3) {
      selectedType = types['FUCK']!; // 操蛋人：高行动+低决策
    } else if (avgScore >= 2.3) {
      selectedType = types['JOKE-R']!; // 小丑：整体较高
    } else if (avgScore <= 1.7) {
      selectedType = types['POOR']!; // 穷人：整体较低
    } else if (selfAvg <= 2.0 && socialAvg <= 2.0) {
      selectedType = types['IMSB']!; // 傻逼：低自我+低社交
    } else if (emotionAvg >= 2.0 && e2 <= 3) {
      selectedType = types['WOC']!; // 卧槽人：中等情感+低投入
    } else {
      // 默认类型
      selectedType = types['ATM-er']!; // 送钱者
    }

    // 计算匹配度（基于与理想人格的接近程度）
    final matchPercentage = ((avgScore / 3) * 100).round().clamp(60, 99);

    return TestResult(
      type: selectedType,
      dimensionScores: dimensionScores,
      matchPercentage: matchPercentage,
    );
  }
}
