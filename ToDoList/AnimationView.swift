import Lottie
import UIKit

class AnimationNoResultsView: UIView {

    private let animation = LottieAnimationView(name: "noResults")
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nenhuma anotação feita"
        label.isHidden = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFunctions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnimationNoResultsView {
    func setupFunctions() {
        setupComponents()
        setupConstraints()
        setupUI()
    }
    
    func setupComponents() {
        addSubview(animation)
        addSubview(label)
    }
    
    func setupConstraints() {
        animation.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(label.snp.top).offset(-30)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(animation.snp.bottom).offset(30)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    func setupUI() {
        animation.play()
        animation.loopMode = .loop
        animation.animationSpeed = 1
        backgroundColor = .white
    }
}
