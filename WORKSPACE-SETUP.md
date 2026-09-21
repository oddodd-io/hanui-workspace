# 작업 공간 복구

부모 저장소를 clone한 뒤 자식 저장소를 각각 clone합니다.

```bash
git clone <hanui-workspace-remote> hanui-workspace
cd hanui-workspace
git clone <hanui-remote> hanui
git clone <hanui-cms-remote> hanui-cms
git clone <krds-checker-remote> krds-checker
git clone <claude-settings-remote> claude-settings
```

자식 저장소의 원격 주소와 현재 작업 브랜치는 각 저장소에서 확인합니다. 부모 저장소는 문서와 참고 자료를 백업하는 용도이며 자식 저장소의 파일을 다시 추적하지 않습니다.
