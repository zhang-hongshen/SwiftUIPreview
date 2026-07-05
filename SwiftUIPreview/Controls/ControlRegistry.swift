enum ControlRegistry {
    static var defaultControls: [AnyControlPreview] {
        availableControls(for: .current)
    }

    static func availableControls(for version: MacOSVersion) -> [AnyControlPreview] {
        allControls.filter { $0.minimumMacOSVersion <= version }
    }

    private static var allControls: [AnyControlPreview] {
        [
            AnyControlPreview(TextPreviewControl()),
            AnyControlPreview(LabelPreviewControl()),
            AnyControlPreview(ImagePreviewControl()),
            AnyControlPreview(AsyncImagePreviewControl()),
            AnyControlPreview(LinkPreviewControl()),
            AnyControlPreview(ButtonPreviewControl()),
            AnyControlPreview(MenuPreviewControl()),
            AnyControlPreview(TogglePreviewControl()),
            AnyControlPreview(PickerPreviewControl()),
            AnyControlPreview(SliderPreviewControl()),
            AnyControlPreview(StepperPreviewControl()),
            AnyControlPreview(TextFieldPreviewControl()),
            AnyControlPreview(SecureFieldPreviewControl()),
            AnyControlPreview(TextEditorPreviewControl()),
            AnyControlPreview(DatePickerPreviewControl()),
            AnyControlPreview(ColorPickerPreviewControl()),
            AnyControlPreview(ProgressViewPreviewControl()),
            AnyControlPreview(GaugePreviewControl()),
            AnyControlPreview(GridPreviewControl()),
            AnyControlPreview(GroupBoxPreviewControl()),
            AnyControlPreview(FormPreviewControl()),
            AnyControlPreview(ListPreviewControl()),
            AnyControlPreview(TablePreviewControl()),
            AnyControlPreview(ScrollViewPreviewControl()),
            AnyControlPreview(DisclosureGroupPreviewControl()),
            AnyControlPreview(NavigationLinkPreviewControl()),
            AnyControlPreview(TabViewPreviewControl()),
            AnyControlPreview(SheetPreviewControl()),
            AnyControlPreview(PopoverPreviewControl()),
            AnyControlPreview(AlertPreviewControl()),
            AnyControlPreview(ConfirmationDialogPreviewControl()),
            AnyControlPreview(SpacerPreviewControl()),
            AnyControlPreview(DividerPreviewControl()),
            AnyControlPreview(RectanglePreviewControl()),
            AnyControlPreview(RoundedRectanglePreviewControl()),
            AnyControlPreview(CirclePreviewControl()),
            AnyControlPreview(EllipsePreviewControl()),
            AnyControlPreview(CapsulePreviewControl()),
            AnyControlPreview(PathPreviewControl()),
            AnyControlPreview(CanvasPreviewControl()),
            AnyControlPreview(TimelineViewPreviewControl()),
            AnyControlPreview(GeometryReaderPreviewControl()),
            AnyControlPreview(AnyLayoutPreviewControl()),
            AnyControlPreview(ShareLinkPreviewControl()),
            AnyControlPreview(PhotosPickerPreviewControl())
        ]
    }
}
