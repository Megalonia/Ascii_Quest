; ModuleID = 'probe1.3a1fbbbh-cgu.0'
source_filename = "probe1.3a1fbbbh-cgu.0"
target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

%"std::fmt::Formatter" = type { [0 x i32], i32, [0 x i32], i32, [0 x i32], { i32, i32 }, [0 x i32], { i32, i32 }, [0 x i32], { {}*, [3 x i32]* }, [0 x i8], i8, [3 x i8] }
%"core::fmt::Opaque" = type {}
%"std::fmt::Arguments" = type { [0 x i32], { [0 x { [0 x i8]*, i32 }]*, i32 }, [0 x i32], { i32*, i32 }, [0 x i32], { [0 x { i8*, i32* }]*, i32 }, [0 x i32] }
%"std::vec::Vec<u8>" = type { [0 x i32], { i8*, i32 }, [0 x i32], i32, [0 x i32] }
%"std::string::String" = type { [0 x i32], %"std::vec::Vec<u8>", [0 x i32] }
%"std::ptr::Repr<u8>" = type { [2 x i32] }
%"std::marker::PhantomData<u8>" = type {}
%"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>" = type { [0 x i32], {}*, [2 x i32] }
%"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>::Some" = type { [0 x i32], { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }, [0 x i32] }
%"std::alloc::Global" = type {}

@alloc1 = private unnamed_addr constant <{ [0 x i8] }> zeroinitializer, align 1
@alloc2 = private unnamed_addr constant <{ i8*, [4 x i8] }> <{ i8* getelementptr inbounds (<{ [0 x i8] }>, <{ [0 x i8] }>* @alloc1, i32 0, i32 0, i32 0), [4 x i8] zeroinitializer }>, align 4
@alloc4 = private unnamed_addr constant <{ [4 x i8] }> zeroinitializer, align 4

; <core::ptr::non_null::NonNull<T> as core::convert::From<core::ptr::unique::Unique<T>>>::from
; Function Attrs: inlinehint nounwind
define hidden nonnull i8* @"_ZN119_$LT$core..ptr..non_null..NonNull$LT$T$GT$$u20$as$u20$core..convert..From$LT$core..ptr..unique..Unique$LT$T$GT$$GT$$GT$4from17hf30125356bf1e98fE"(i8* nonnull %unique) unnamed_addr #0 {
start:
; call core::ptr::unique::Unique<T>::as_ptr
  %_2 = call i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17h098c782a6ce0e9d9E"(i8* nonnull %unique)
  br label %bb1

bb1:                                              ; preds = %start
; call core::ptr::non_null::NonNull<T>::new_unchecked
  %0 = call nonnull i8* @"_ZN4core3ptr8non_null16NonNull$LT$T$GT$13new_unchecked17h4ddb8eca21b08448E"(i8* %_2)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i8* %0
}

; core::fmt::ArgumentV1::new
; Function Attrs: nounwind
define hidden { i8*, i32* } @_ZN4core3fmt10ArgumentV13new17h81f721725e1df254E(i32* noalias readonly align 4 dereferenceable(4) %x, i1 (i32*, %"std::fmt::Formatter"*)* nonnull %f) unnamed_addr #1 {
start:
  %0 = alloca %"core::fmt::Opaque"*, align 4
  %1 = alloca i1 (%"core::fmt::Opaque"*, %"std::fmt::Formatter"*)*, align 4
  %2 = alloca { i8*, i32* }, align 4
  %3 = bitcast i1 (%"core::fmt::Opaque"*, %"std::fmt::Formatter"*)** %1 to i1 (i32*, %"std::fmt::Formatter"*)**
  store i1 (i32*, %"std::fmt::Formatter"*)* %f, i1 (i32*, %"std::fmt::Formatter"*)** %3, align 4
  %_3 = load i1 (%"core::fmt::Opaque"*, %"std::fmt::Formatter"*)*, i1 (%"core::fmt::Opaque"*, %"std::fmt::Formatter"*)** %1, align 4, !nonnull !0
  br label %bb1

bb1:                                              ; preds = %start
  %4 = bitcast %"core::fmt::Opaque"** %0 to i32**
  store i32* %x, i32** %4, align 4
  %_5 = load %"core::fmt::Opaque"*, %"core::fmt::Opaque"** %0, align 4, !nonnull !0
  br label %bb2

bb2:                                              ; preds = %bb1
  %5 = bitcast { i8*, i32* }* %2 to %"core::fmt::Opaque"**
  store %"core::fmt::Opaque"* %_5, %"core::fmt::Opaque"** %5, align 4
  %6 = getelementptr inbounds { i8*, i32* }, { i8*, i32* }* %2, i32 0, i32 1
  %7 = bitcast i32** %6 to i1 (%"core::fmt::Opaque"*, %"std::fmt::Formatter"*)**
  store i1 (%"core::fmt::Opaque"*, %"std::fmt::Formatter"*)* %_3, i1 (%"core::fmt::Opaque"*, %"std::fmt::Formatter"*)** %7, align 4
  %8 = getelementptr inbounds { i8*, i32* }, { i8*, i32* }* %2, i32 0, i32 0
  %9 = load i8*, i8** %8, align 4, !nonnull !0
  %10 = getelementptr inbounds { i8*, i32* }, { i8*, i32* }* %2, i32 0, i32 1
  %11 = load i32*, i32** %10, align 4, !nonnull !0
  %12 = insertvalue { i8*, i32* } undef, i8* %9, 0
  %13 = insertvalue { i8*, i32* } %12, i32* %11, 1
  ret { i8*, i32* } %13
}

; core::fmt::Arguments::new_v1
; Function Attrs: inlinehint nounwind
define internal void @_ZN4core3fmt9Arguments6new_v117h047061328d503efaE(%"std::fmt::Arguments"* noalias nocapture sret dereferenceable(24) %0, [0 x { [0 x i8]*, i32 }]* noalias nonnull readonly align 4 %pieces.0, i32 %pieces.1, [0 x { i8*, i32* }]* noalias nonnull readonly align 4 %args.0, i32 %args.1) unnamed_addr #0 {
start:
  %_4 = alloca { i32*, i32 }, align 4
  %1 = bitcast { i32*, i32 }* %_4 to {}**
  store {}* null, {}** %1, align 4
  %2 = bitcast %"std::fmt::Arguments"* %0 to { [0 x { [0 x i8]*, i32 }]*, i32 }*
  %3 = getelementptr inbounds { [0 x { [0 x i8]*, i32 }]*, i32 }, { [0 x { [0 x i8]*, i32 }]*, i32 }* %2, i32 0, i32 0
  store [0 x { [0 x i8]*, i32 }]* %pieces.0, [0 x { [0 x i8]*, i32 }]** %3, align 4
  %4 = getelementptr inbounds { [0 x { [0 x i8]*, i32 }]*, i32 }, { [0 x { [0 x i8]*, i32 }]*, i32 }* %2, i32 0, i32 1
  store i32 %pieces.1, i32* %4, align 4
  %5 = getelementptr inbounds %"std::fmt::Arguments", %"std::fmt::Arguments"* %0, i32 0, i32 3
  %6 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %_4, i32 0, i32 0
  %7 = load i32*, i32** %6, align 4
  %8 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %_4, i32 0, i32 1
  %9 = load i32, i32* %8, align 4
  %10 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %5, i32 0, i32 0
  store i32* %7, i32** %10, align 4
  %11 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %5, i32 0, i32 1
  store i32 %9, i32* %11, align 4
  %12 = getelementptr inbounds %"std::fmt::Arguments", %"std::fmt::Arguments"* %0, i32 0, i32 5
  %13 = getelementptr inbounds { [0 x { i8*, i32* }]*, i32 }, { [0 x { i8*, i32* }]*, i32 }* %12, i32 0, i32 0
  store [0 x { i8*, i32* }]* %args.0, [0 x { i8*, i32* }]** %13, align 4
  %14 = getelementptr inbounds { [0 x { i8*, i32* }]*, i32 }, { [0 x { i8*, i32* }]*, i32 }* %12, i32 0, i32 1
  store i32 %args.1, i32* %14, align 4
  ret void
}

; core::num::nonzero::NonZeroUsize::new_unchecked
; Function Attrs: inlinehint nounwind
define internal i32 @_ZN4core3num7nonzero12NonZeroUsize13new_unchecked17h418014a4187ca19cE(i32 %n) unnamed_addr #0 {
start:
  %0 = alloca i32, align 4
  store i32 %n, i32* %0, align 4
  %1 = load i32, i32* %0, align 4, !range !1
  ret i32 %1
}

; core::num::nonzero::NonZeroUsize::get
; Function Attrs: inlinehint nounwind
define internal i32 @_ZN4core3num7nonzero12NonZeroUsize3get17h68178b5ed03ff7e7E(i32 %self) unnamed_addr #0 {
start:
  ret i32 %self
}

; core::ptr::drop_in_place
; Function Attrs: nounwind
define hidden void @_ZN4core3ptr13drop_in_place17h311737643efdf205E(%"std::vec::Vec<u8>"* %_1) unnamed_addr #1 {
start:
  %0 = alloca {}, align 1
; call <alloc::vec::Vec<T> as core::ops::drop::Drop>::drop
  call void @"_ZN66_$LT$alloc..vec..Vec$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hc8cd86436a79a74eE"(%"std::vec::Vec<u8>"* align 4 dereferenceable(12) %_1)
  br label %bb2

bb1:                                              ; preds = %bb2
  ret void

bb2:                                              ; preds = %start
  %1 = bitcast %"std::vec::Vec<u8>"* %_1 to { i8*, i32 }*
; call core::ptr::drop_in_place
  call void @_ZN4core3ptr13drop_in_place17hd1bbf1c7a9c5581bE({ i8*, i32 }* %1)
  br label %bb1
}

; core::ptr::drop_in_place
; Function Attrs: nounwind
define hidden void @_ZN4core3ptr13drop_in_place17h4c5ba727ebf6eb24E(%"std::string::String"* %_1) unnamed_addr #1 {
start:
  %0 = alloca {}, align 1
  %1 = bitcast %"std::string::String"* %_1 to %"std::vec::Vec<u8>"*
; call core::ptr::drop_in_place
  call void @_ZN4core3ptr13drop_in_place17h311737643efdf205E(%"std::vec::Vec<u8>"* %1)
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; core::ptr::drop_in_place
; Function Attrs: nounwind
define hidden void @_ZN4core3ptr13drop_in_place17hd1bbf1c7a9c5581bE({ i8*, i32 }* %_1) unnamed_addr #1 {
start:
  %0 = alloca {}, align 1
; call <alloc::raw_vec::RawVec<T,A> as core::ops::drop::Drop>::drop
  call void @"_ZN77_$LT$alloc..raw_vec..RawVec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hd5a79533067cd7aaE"({ i8*, i32 }* align 4 dereferenceable(8) %_1)
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; core::ptr::slice_from_raw_parts_mut
; Function Attrs: inlinehint nounwind
define hidden { [0 x i8]*, i32 } @_ZN4core3ptr24slice_from_raw_parts_mut17h8d0914178a3ecb90E(i8* %data, i32 %len) unnamed_addr #0 {
start:
  %_4 = alloca { i8*, i32 }, align 4
  %_3 = alloca %"std::ptr::Repr<u8>", align 4
  %0 = bitcast { i8*, i32 }* %_4 to i8**
  store i8* %data, i8** %0, align 4
  %1 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %_4, i32 0, i32 1
  store i32 %len, i32* %1, align 4
  %2 = bitcast %"std::ptr::Repr<u8>"* %_3 to { i8*, i32 }*
  %3 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %_4, i32 0, i32 0
  %4 = load i8*, i8** %3, align 4
  %5 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %_4, i32 0, i32 1
  %6 = load i32, i32* %5, align 4
  %7 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %2, i32 0, i32 0
  store i8* %4, i8** %7, align 4
  %8 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %2, i32 0, i32 1
  store i32 %6, i32* %8, align 4
  %9 = bitcast %"std::ptr::Repr<u8>"* %_3 to { [0 x i8]*, i32 }*
  %10 = getelementptr inbounds { [0 x i8]*, i32 }, { [0 x i8]*, i32 }* %9, i32 0, i32 0
  %11 = load [0 x i8]*, [0 x i8]** %10, align 4
  %12 = getelementptr inbounds { [0 x i8]*, i32 }, { [0 x i8]*, i32 }* %9, i32 0, i32 1
  %13 = load i32, i32* %12, align 4
  %14 = insertvalue { [0 x i8]*, i32 } undef, [0 x i8]* %11, 0
  %15 = insertvalue { [0 x i8]*, i32 } %14, i32 %13, 1
  ret { [0 x i8]*, i32 } %15
}

; core::ptr::unique::Unique<T>::new_unchecked
; Function Attrs: inlinehint nounwind
define hidden nonnull i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$13new_unchecked17h28be1dcf03095ad5E"(i8* %ptr) unnamed_addr #0 {
start:
  %_5 = alloca %"std::marker::PhantomData<u8>", align 1
  %0 = alloca i8*, align 4
  store i8* %ptr, i8** %0, align 4
  %1 = bitcast i8** %0 to %"std::marker::PhantomData<u8>"*
  %2 = load i8*, i8** %0, align 4, !nonnull !0
  ret i8* %2
}

; core::ptr::unique::Unique<T>::cast
; Function Attrs: inlinehint nounwind
define hidden nonnull i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$4cast17hda126e660c5a9d70E"(i8* nonnull %self) unnamed_addr #0 {
start:
; call core::ptr::unique::Unique<T>::as_ptr
  %_3 = call i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17h098c782a6ce0e9d9E"(i8* nonnull %self)
  br label %bb1

bb1:                                              ; preds = %start
; call core::ptr::unique::Unique<T>::new_unchecked
  %0 = call nonnull i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$13new_unchecked17h28be1dcf03095ad5E"(i8* %_3)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i8* %0
}

; core::ptr::unique::Unique<T>::as_ptr
; Function Attrs: inlinehint nounwind
define hidden i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17h098c782a6ce0e9d9E"(i8* nonnull %self) unnamed_addr #0 {
start:
  ret i8* %self
}

; core::ptr::mut_ptr::<impl *mut T>::guaranteed_eq
; Function Attrs: inlinehint nounwind
define hidden zeroext i1 @"_ZN4core3ptr7mut_ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$13guaranteed_eq17hec46c8becfd02b16E"(i8* %self, i8* %other) unnamed_addr #0 {
start:
  %0 = alloca i8, align 1
  %1 = icmp eq i8* %self, %other
  %2 = zext i1 %1 to i8
  store i8 %2, i8* %0, align 1
  %3 = load i8, i8* %0, align 1, !range !2
  %4 = trunc i8 %3 to i1
  br label %bb1

bb1:                                              ; preds = %start
  ret i1 %4
}

; core::ptr::mut_ptr::<impl *mut T>::is_null
; Function Attrs: inlinehint nounwind
define hidden zeroext i1 @"_ZN4core3ptr7mut_ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$7is_null17hac1822a70318f2f9E"(i8* %self) unnamed_addr #0 {
start:
  br label %bb1

bb1:                                              ; preds = %start
; call core::ptr::mut_ptr::<impl *mut T>::guaranteed_eq
  %0 = call zeroext i1 @"_ZN4core3ptr7mut_ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$13guaranteed_eq17hec46c8becfd02b16E"(i8* %self, i8* null)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i1 %0
}

; core::ptr::non_null::NonNull<T>::new_unchecked
; Function Attrs: inlinehint nounwind
define hidden nonnull i8* @"_ZN4core3ptr8non_null16NonNull$LT$T$GT$13new_unchecked17h4ddb8eca21b08448E"(i8* %ptr) unnamed_addr #0 {
start:
  %0 = alloca i8*, align 4
  store i8* %ptr, i8** %0, align 4
  %1 = load i8*, i8** %0, align 4, !nonnull !0
  ret i8* %1
}

; core::ptr::non_null::NonNull<T>::as_ptr
; Function Attrs: inlinehint nounwind
define hidden i8* @"_ZN4core3ptr8non_null16NonNull$LT$T$GT$6as_ptr17h7b13ea11a2dbc80eE"(i8* nonnull %self) unnamed_addr #0 {
start:
  ret i8* %self
}

; core::alloc::layout::Layout::from_size_align_unchecked
; Function Attrs: inlinehint nounwind
define internal { i32, i32 } @_ZN4core5alloc6layout6Layout25from_size_align_unchecked17hfa5d3266e684ceffE(i32 %size, i32 %align) unnamed_addr #0 {
start:
  %0 = alloca { i32, i32 }, align 4
; call core::num::nonzero::NonZeroUsize::new_unchecked
  %_4 = call i32 @_ZN4core3num7nonzero12NonZeroUsize13new_unchecked17h418014a4187ca19cE(i32 %align), !range !1
  br label %bb1

bb1:                                              ; preds = %start
  %1 = bitcast { i32, i32 }* %0 to i32*
  store i32 %size, i32* %1, align 4
  %2 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %0, i32 0, i32 1
  store i32 %_4, i32* %2, align 4
  %3 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %0, i32 0, i32 0
  %4 = load i32, i32* %3, align 4
  %5 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %0, i32 0, i32 1
  %6 = load i32, i32* %5, align 4, !range !1
  %7 = insertvalue { i32, i32 } undef, i32 %4, 0
  %8 = insertvalue { i32, i32 } %7, i32 %6, 1
  ret { i32, i32 } %8
}

; core::alloc::layout::Layout::size
; Function Attrs: inlinehint nounwind
define internal i32 @_ZN4core5alloc6layout6Layout4size17h7d8b0f518cbf9b11E({ i32, i32 }* noalias readonly align 4 dereferenceable(8) %self) unnamed_addr #0 {
start:
  %0 = bitcast { i32, i32 }* %self to i32*
  %1 = load i32, i32* %0, align 4
  ret i32 %1
}

; core::alloc::layout::Layout::align
; Function Attrs: inlinehint nounwind
define internal i32 @_ZN4core5alloc6layout6Layout5align17h8d34a46c705dbd3eE({ i32, i32 }* noalias readonly align 4 dereferenceable(8) %self) unnamed_addr #0 {
start:
  %0 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %self, i32 0, i32 1
  %_2 = load i32, i32* %0, align 4, !range !1
; call core::num::nonzero::NonZeroUsize::get
  %1 = call i32 @_ZN4core3num7nonzero12NonZeroUsize3get17h68178b5ed03ff7e7E(i32 %_2)
  br label %bb1

bb1:                                              ; preds = %start
  ret i32 %1
}

; <T as core::convert::Into<U>>::into
; Function Attrs: nounwind
define hidden nonnull i8* @"_ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h82fd5a064318c4d8E"(i8* nonnull %self) unnamed_addr #1 {
start:
; call <core::ptr::non_null::NonNull<T> as core::convert::From<core::ptr::unique::Unique<T>>>::from
  %0 = call nonnull i8* @"_ZN119_$LT$core..ptr..non_null..NonNull$LT$T$GT$$u20$as$u20$core..convert..From$LT$core..ptr..unique..Unique$LT$T$GT$$GT$$GT$4from17hf30125356bf1e98fE"(i8* nonnull %self)
  br label %bb1

bb1:                                              ; preds = %start
  ret i8* %0
}

; alloc::vec::Vec<T>::as_mut_ptr
; Function Attrs: inlinehint nounwind
define hidden i8* @"_ZN5alloc3vec12Vec$LT$T$GT$10as_mut_ptr17h44997ce030307754E"(%"std::vec::Vec<u8>"* align 4 dereferenceable(12) %self) unnamed_addr #0 {
start:
  %_2 = bitcast %"std::vec::Vec<u8>"* %self to { i8*, i32 }*
; call alloc::raw_vec::RawVec<T,A>::ptr
  %ptr = call i8* @"_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$3ptr17hf973c211b2f408b6E"({ i8*, i32 }* noalias readonly align 4 dereferenceable(8) %_2)
  br label %bb1

bb1:                                              ; preds = %start
; call core::ptr::mut_ptr::<impl *mut T>::is_null
  %_5 = call zeroext i1 @"_ZN4core3ptr7mut_ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$7is_null17hac1822a70318f2f9E"(i8* %ptr)
  br label %bb2

bb2:                                              ; preds = %bb1
  %_4 = xor i1 %_5, true
  call void @llvm.assume(i1 %_4)
  br label %bb3

bb3:                                              ; preds = %bb2
  ret i8* %ptr
}

; alloc::alloc::dealloc
; Function Attrs: inlinehint nounwind
define internal void @_ZN5alloc5alloc7dealloc17ha51dc4c6e1963b9bE(i8* %ptr, i32 %0, i32 %1) unnamed_addr #0 {
start:
  %layout = alloca { i32, i32 }, align 4
  %2 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %layout, i32 0, i32 0
  store i32 %0, i32* %2, align 4
  %3 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %layout, i32 0, i32 1
  store i32 %1, i32* %3, align 4
; call core::alloc::layout::Layout::size
  %_4 = call i32 @_ZN4core5alloc6layout6Layout4size17h7d8b0f518cbf9b11E({ i32, i32 }* noalias readonly align 4 dereferenceable(8) %layout)
  br label %bb1

bb1:                                              ; preds = %start
; call core::alloc::layout::Layout::align
  %_6 = call i32 @_ZN4core5alloc6layout6Layout5align17h8d34a46c705dbd3eE({ i32, i32 }* noalias readonly align 4 dereferenceable(8) %layout)
  br label %bb2

bb2:                                              ; preds = %bb1
  call void @__rust_dealloc(i8* %ptr, i32 %_4, i32 %_6)
  br label %bb3

bb3:                                              ; preds = %bb2
  ret void
}

; alloc::raw_vec::RawVec<T,A>::current_memory
; Function Attrs: nounwind
define hidden void @"_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$14current_memory17h3e5aa219ea67b0caE"(%"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>"* noalias nocapture sret dereferenceable(12) %0, { i8*, i32 }* noalias readonly align 4 dereferenceable(8) %self) unnamed_addr #1 {
start:
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %_12 = alloca { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }, align 4
  %_2 = alloca i8, align 1
  store i32 1, i32* %3, align 4
  %4 = load i32, i32* %3, align 4
  br label %bb5

bb1:                                              ; preds = %bb3, %bb5
  store i8 1, i8* %_2, align 1
  br label %bb4

bb2:                                              ; preds = %bb3
  store i8 0, i8* %_2, align 1
  br label %bb4

bb3:                                              ; preds = %bb5
  %5 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %self, i32 0, i32 1
  %_4 = load i32, i32* %5, align 4
  %6 = icmp eq i32 %_4, 0
  br i1 %6, label %bb1, label %bb2

bb4:                                              ; preds = %bb1, %bb2
  %7 = load i8, i8* %_2, align 1, !range !2
  %8 = trunc i8 %7 to i1
  br i1 %8, label %bb7, label %bb6

bb5:                                              ; preds = %start
  %9 = icmp eq i32 %4, 0
  br i1 %9, label %bb1, label %bb3

bb6:                                              ; preds = %bb4
  store i32 1, i32* %2, align 4
  %10 = load i32, i32* %2, align 4
  br label %bb8

bb7:                                              ; preds = %bb4
  %11 = bitcast %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>"* %0 to {}**
  store {}* null, {}** %11, align 4
  br label %bb13

bb8:                                              ; preds = %bb6
  store i32 1, i32* %1, align 4
  %12 = load i32, i32* %1, align 4
  br label %bb9

bb9:                                              ; preds = %bb8
  %13 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %self, i32 0, i32 1
  %_8 = load i32, i32* %13, align 4
  %size = mul i32 %12, %_8
; call core::alloc::layout::Layout::from_size_align_unchecked
  %14 = call { i32, i32 } @_ZN4core5alloc6layout6Layout25from_size_align_unchecked17hfa5d3266e684ceffE(i32 %size, i32 %10)
  %layout.0 = extractvalue { i32, i32 } %14, 0
  %layout.1 = extractvalue { i32, i32 } %14, 1
  br label %bb10

bb10:                                             ; preds = %bb9
  %15 = bitcast { i8*, i32 }* %self to i8**
  %_15 = load i8*, i8** %15, align 4, !nonnull !0
; call core::ptr::unique::Unique<T>::cast
  %_14 = call nonnull i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$4cast17hda126e660c5a9d70E"(i8* nonnull %_15)
  br label %bb11

bb11:                                             ; preds = %bb10
; call <T as core::convert::Into<U>>::into
  %_13 = call nonnull i8* @"_ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h82fd5a064318c4d8E"(i8* nonnull %_14)
  br label %bb12

bb12:                                             ; preds = %bb11
  %16 = bitcast { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }* %_12 to i8**
  store i8* %_13, i8** %16, align 4
  %17 = getelementptr inbounds { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }, { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }* %_12, i32 0, i32 3
  %18 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %17, i32 0, i32 0
  store i32 %layout.0, i32* %18, align 4
  %19 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %17, i32 0, i32 1
  store i32 %layout.1, i32* %19, align 4
  %20 = bitcast %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>"* %0 to %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>::Some"*
  %21 = bitcast %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>::Some"* %20 to { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }*
  %22 = bitcast { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }* %21 to i8*
  %23 = bitcast { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }* %_12 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %22, i8* align 4 %23, i32 12, i1 false)
  br label %bb13

bb13:                                             ; preds = %bb12, %bb7
  ret void
}

; alloc::raw_vec::RawVec<T,A>::ptr
; Function Attrs: nounwind
define hidden i8* @"_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$3ptr17hf973c211b2f408b6E"({ i8*, i32 }* noalias readonly align 4 dereferenceable(8) %self) unnamed_addr #1 {
start:
  %0 = bitcast { i8*, i32 }* %self to i8**
  %_2 = load i8*, i8** %0, align 4, !nonnull !0
; call core::ptr::unique::Unique<T>::as_ptr
  %1 = call i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17h098c782a6ce0e9d9E"(i8* nonnull %_2)
  br label %bb1

bb1:                                              ; preds = %start
  ret i8* %1
}

; <alloc::alloc::Global as core::alloc::AllocRef>::dealloc
; Function Attrs: inlinehint nounwind
define internal void @"_ZN62_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..AllocRef$GT$7dealloc17h1aa3f86d7b29aa5cE"(%"std::alloc::Global"* noalias nonnull readonly align 1 %self, i8* nonnull %ptr, i32 %0, i32 %1) unnamed_addr #0 {
start:
  %2 = alloca {}, align 1
  %layout = alloca { i32, i32 }, align 4
  %3 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %layout, i32 0, i32 0
  store i32 %0, i32* %3, align 4
  %4 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %layout, i32 0, i32 1
  store i32 %1, i32* %4, align 4
; call core::alloc::layout::Layout::size
  %_4 = call i32 @_ZN4core5alloc6layout6Layout4size17h7d8b0f518cbf9b11E({ i32, i32 }* noalias readonly align 4 dereferenceable(8) %layout)
  br label %bb1

bb1:                                              ; preds = %start
  %5 = icmp eq i32 %_4, 0
  br i1 %5, label %bb2, label %bb3

bb2:                                              ; preds = %bb1
  br label %bb6

bb3:                                              ; preds = %bb1
; call core::ptr::non_null::NonNull<T>::as_ptr
  %_6 = call i8* @"_ZN4core3ptr8non_null16NonNull$LT$T$GT$6as_ptr17h7b13ea11a2dbc80eE"(i8* nonnull %ptr)
  br label %bb4

bb4:                                              ; preds = %bb3
  %6 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %layout, i32 0, i32 0
  %_8.0 = load i32, i32* %6, align 4
  %7 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %layout, i32 0, i32 1
  %_8.1 = load i32, i32* %7, align 4, !range !1
; call alloc::alloc::dealloc
  call void @_ZN5alloc5alloc7dealloc17ha51dc4c6e1963b9bE(i8* %_6, i32 %_8.0, i32 %_8.1)
  br label %bb5

bb5:                                              ; preds = %bb4
  br label %bb6

bb6:                                              ; preds = %bb2, %bb5
  ret void
}

; <alloc::vec::Vec<T> as core::ops::drop::Drop>::drop
; Function Attrs: nounwind
define hidden void @"_ZN66_$LT$alloc..vec..Vec$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hc8cd86436a79a74eE"(%"std::vec::Vec<u8>"* align 4 dereferenceable(12) %self) unnamed_addr #1 {
start:
; call alloc::vec::Vec<T>::as_mut_ptr
  %_3 = call i8* @"_ZN5alloc3vec12Vec$LT$T$GT$10as_mut_ptr17h44997ce030307754E"(%"std::vec::Vec<u8>"* align 4 dereferenceable(12) %self)
  br label %bb1

bb1:                                              ; preds = %start
  %0 = getelementptr inbounds %"std::vec::Vec<u8>", %"std::vec::Vec<u8>"* %self, i32 0, i32 3
  %_5 = load i32, i32* %0, align 4
; call core::ptr::slice_from_raw_parts_mut
  %1 = call { [0 x i8]*, i32 } @_ZN4core3ptr24slice_from_raw_parts_mut17h8d0914178a3ecb90E(i8* %_3, i32 %_5)
  %_2.0 = extractvalue { [0 x i8]*, i32 } %1, 0
  %_2.1 = extractvalue { [0 x i8]*, i32 } %1, 1
  br label %bb2

bb2:                                              ; preds = %bb1
  br label %bb3

bb3:                                              ; preds = %bb2
  ret void
}

; <alloc::raw_vec::RawVec<T,A> as core::ops::drop::Drop>::drop
; Function Attrs: nounwind
define hidden void @"_ZN77_$LT$alloc..raw_vec..RawVec$LT$T$C$A$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17hd5a79533067cd7aaE"({ i8*, i32 }* align 4 dereferenceable(8) %self) unnamed_addr #1 {
start:
  %_2 = alloca %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>", align 4
  %0 = alloca {}, align 1
; call alloc::raw_vec::RawVec<T,A>::current_memory
  call void @"_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$14current_memory17h3e5aa219ea67b0caE"(%"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>"* noalias nocapture sret dereferenceable(12) %_2, { i8*, i32 }* noalias readonly align 4 dereferenceable(8) %self)
  br label %bb1

bb1:                                              ; preds = %start
  %1 = bitcast %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>"* %_2 to {}**
  %2 = load {}*, {}** %1, align 4
  %3 = icmp eq {}* %2, null
  %_4 = select i1 %3, i32 0, i32 1
  %4 = icmp eq i32 %_4, 1
  br i1 %4, label %bb3, label %bb2

bb2:                                              ; preds = %bb1
  br label %bb5

bb3:                                              ; preds = %bb1
  %5 = bitcast %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>"* %_2 to %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>::Some"*
  %6 = bitcast %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>::Some"* %5 to { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }*
  %7 = bitcast { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }* %6 to i8**
  %ptr = load i8*, i8** %7, align 4, !nonnull !0
  %8 = bitcast %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>"* %_2 to %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>::Some"*
  %9 = bitcast %"std::option::Option<(std::ptr::NonNull<u8>, std::alloc::Layout)>::Some"* %8 to { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }*
  %10 = getelementptr inbounds { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }, { [0 x i32], i8*, [0 x i32], { i32, i32 }, [0 x i32] }* %9, i32 0, i32 3
  %11 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %10, i32 0, i32 0
  %layout.0 = load i32, i32* %11, align 4
  %12 = getelementptr inbounds { i32, i32 }, { i32, i32 }* %10, i32 0, i32 1
  %layout.1 = load i32, i32* %12, align 4, !range !1
  %_7 = bitcast { i8*, i32 }* %self to %"std::alloc::Global"*
; call <alloc::alloc::Global as core::alloc::AllocRef>::dealloc
  call void @"_ZN62_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..AllocRef$GT$7dealloc17h1aa3f86d7b29aa5cE"(%"std::alloc::Global"* noalias nonnull readonly align 1 %_7, i8* nonnull %ptr, i32 %layout.0, i32 %layout.1)
  br label %bb4

bb4:                                              ; preds = %bb3
  br label %bb5

bb5:                                              ; preds = %bb4, %bb2
  ret void
}

; probe1::probe
; Function Attrs: nounwind
define hidden void @_ZN6probe15probe17hcc631d850158b26eE() unnamed_addr #1 {
start:
  %_11 = alloca i32*, align 4
  %_10 = alloca [1 x { i8*, i32* }], align 4
  %_3 = alloca %"std::fmt::Arguments", align 4
  %res = alloca %"std::string::String", align 4
  %_1 = alloca %"std::string::String", align 4
  store i32* bitcast (<{ [4 x i8] }>* @alloc4 to i32*), i32** %_11, align 4
  %arg0 = load i32*, i32** %_11, align 4, !nonnull !0
; call core::fmt::ArgumentV1::new
  %0 = call { i8*, i32* } @_ZN4core3fmt10ArgumentV13new17h81f721725e1df254E(i32* noalias readonly align 4 dereferenceable(4) %arg0, i1 (i32*, %"std::fmt::Formatter"*)* nonnull @"_ZN4core3fmt3num3imp55_$LT$impl$u20$core..fmt..LowerExp$u20$for$u20$isize$GT$3fmt17h9db517a134e16fc2E")
  %_14.0 = extractvalue { i8*, i32* } %0, 0
  %_14.1 = extractvalue { i8*, i32* } %0, 1
  br label %bb1

bb1:                                              ; preds = %start
  %1 = bitcast [1 x { i8*, i32* }]* %_10 to { i8*, i32* }*
  %2 = getelementptr inbounds { i8*, i32* }, { i8*, i32* }* %1, i32 0, i32 0
  store i8* %_14.0, i8** %2, align 4
  %3 = getelementptr inbounds { i8*, i32* }, { i8*, i32* }* %1, i32 0, i32 1
  store i32* %_14.1, i32** %3, align 4
  %_7.0 = bitcast [1 x { i8*, i32* }]* %_10 to [0 x { i8*, i32* }]*
; call core::fmt::Arguments::new_v1
  call void @_ZN4core3fmt9Arguments6new_v117h047061328d503efaE(%"std::fmt::Arguments"* noalias nocapture sret dereferenceable(24) %_3, [0 x { [0 x i8]*, i32 }]* noalias nonnull readonly align 4 bitcast (<{ i8*, [4 x i8] }>* @alloc2 to [0 x { [0 x i8]*, i32 }]*), i32 1, [0 x { i8*, i32* }]* noalias nonnull readonly align 4 %_7.0, i32 1)
  br label %bb2

bb2:                                              ; preds = %bb1
; call alloc::fmt::format
  call void @_ZN5alloc3fmt6format17hb786be8f7eacdff5E(%"std::string::String"* noalias nocapture sret dereferenceable(12) %res, %"std::fmt::Arguments"* noalias nocapture dereferenceable(24) %_3)
  br label %bb3

bb3:                                              ; preds = %bb2
  %4 = bitcast %"std::string::String"* %_1 to i8*
  %5 = bitcast %"std::string::String"* %res to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %4, i8* align 4 %5, i32 12, i1 false)
; call core::ptr::drop_in_place
  call void @_ZN4core3ptr13drop_in_place17h4c5ba727ebf6eb24E(%"std::string::String"* %_1)
  br label %bb4

bb4:                                              ; preds = %bb3
  ret void
}

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #2

; Function Attrs: nounwind
declare void @__rust_dealloc(i8*, i32, i32) unnamed_addr #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i32, i1 immarg) #3

; core::fmt::num::imp::<impl core::fmt::LowerExp for isize>::fmt
; Function Attrs: nounwind
declare zeroext i1 @"_ZN4core3fmt3num3imp55_$LT$impl$u20$core..fmt..LowerExp$u20$for$u20$isize$GT$3fmt17h9db517a134e16fc2E"(i32* noalias readonly align 4 dereferenceable(4), %"std::fmt::Formatter"* align 4 dereferenceable(36)) unnamed_addr #1

; alloc::fmt::format
; Function Attrs: nounwind
declare void @_ZN5alloc3fmt6format17hb786be8f7eacdff5E(%"std::string::String"* noalias nocapture sret dereferenceable(12), %"std::fmt::Arguments"* noalias nocapture dereferenceable(24)) unnamed_addr #1

attributes #0 = { inlinehint nounwind "target-cpu"="generic" }
attributes #1 = { nounwind "target-cpu"="generic" }
attributes #2 = { nounwind willreturn }
attributes #3 = { argmemonly nounwind willreturn }

!0 = !{}
!1 = !{i32 1, i32 0}
!2 = !{i8 0, i8 2}
