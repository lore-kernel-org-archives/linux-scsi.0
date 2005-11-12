From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 0/15] Decrapify FlashPoint.c
Date: Sun, 13 Nov 2005 01:13:08 +0300
Message-ID: <20051112221308.GE20860@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.201]:64859 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964817AbVKLV7c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Nov 2005 16:59:32 -0500
Received: by xproxy.gmail.com with SMTP id s6so1261472wxc
        for <linux-scsi@vger.kernel.org>; Sat, 12 Nov 2005 13:59:32 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>

	Dear SCSI crew,

Please, apply the following patches to drivers/scsi/FlashPoint.c file.
Due to sizes of some of them, I won't CC linux-scsi. The tarball is
available at

	http://coderock.org/kj/flashpoint.tar.bz2	(66k)

or, in splitted form, at

	http://coderock.org/kj/flashpoint/

They were in -kj tree since early July without complaints. All of them
are compile-tested with CONFIG_SCSI_OMIT_FLASHPOINT=y and =n.

						Sincerely yours,
								Alexey
------------------------------------------------------------------------
001_drivers_scsi_flashpoint_c_remove_unused_things.patch
002_drivers_scsi_flashpoint_c_remove_trivial_wrappers.patch
003_drivers_scsi_flashpoint_c_remove_uchar.patch
004_drivers_scsi_flashpoint_c_remove_ushort.patch
005_drivers_scsi_flashpoint_c_remove_uint.patch
006_drivers_scsi_flashpoint_c_remove_ulong.patch
007_drivers_scsi_flashpoint_c_remove_ushort_ptr.patch
008_drivers_scsi_flashpoint_c_use_standard_fixed_size_types.patch
009_drivers_scsi_flashpoint_c_untypedef_struct__sccb.patch
010_drivers_scsi_flashpoint_c_untypedef_struct_sccbmgr_info.patch
011_drivers_scsi_flashpoint_c_untypedef_struct_sccbmgr_tar_info.patch
012_drivers_scsi_flashpoint_c_untypedef_struct_nvraminfo.patch
013_drivers_scsi_flashpoint_c_untypedef_struct_sccbcard.patch
014_drivers_scsi_flashpoint_c_lindent.patch
015_drivers_scsi_flashpoint_c_dont_use_parenthesis_with_return.patch
------------------------------------------------------------------------
[PATCH 01/15] drivers/scsi/FlashPoint.c: remove unused things

From: Alexey Dobriyan <adobriyan@gmail.com>

* Remove unused #define's
* Remove unused typedefs.
* Remove prototypes for non-existing functions.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 02/15] drivers/scsi/FlashPoint.c: remove trivial wrappers

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 03/15] drivers/scsi/FlashPoint.c: remove UCHAR

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 04/15] drivers/scsi/FlashPoint.c: remove USHORT

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 05/15] drivers/scsi/FlashPoint.c: remove UINT

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 06/15] drivers/scsi/FlashPoint.c: remove ULONG

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 07/15] drivers/scsi/FlashPoint.c: remove ushort_ptr

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 08/15] drivers/scsi/FlashPoint.c: use standard fixed size types

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 09/15] drivers/scsi/FlashPoint.c: untypedef struct _SCCB

From: Alexey Dobriyan <adobriyan@gmail.com>

* struct _SCCB => struct sccb
* PSCCB => struct sccb *
* SCCB => struct sccb

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 10/15] drivers/scsi/FlashPoint.c: untypedef struct SCCBMgr_info

From: Alexey Dobriyan <adobriyan@gmail.com>

* struct SCCBMgr_info => struct sccb_mgr_info
* PSCCBMGR_INFO => struct sccb_mgr_info *
* SCCBMGR_INFO => struct sccb_mgr_info

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 11/15] drivers/scsi/FlashPoint.c: untypedef struct SCCBMgr_tar_info

From: Alexey Dobriyan <adobriyan@gmail.com>

* struct SCCBMgr_tar_info => struct sccb_mgr_tar_info
* PSCCBMgr_tar_info => struct sccb_mgr_tar_info *
* SCCBMGR_TAR_INFO => struct sccb_mgr_tar_info

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 12/15] drivers/scsi/FlashPoint.c: untypedef struct NVRAMInfo

From: Alexey Dobriyan <adobriyan@gmail.com>

* struct NVRAMInfo => struct nvram_info
* PNVRamInfo => struct nvram_info *
* NVRAMINFO => struct nvram_info

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 13/15] drivers/scsi/FlashPoint.c: untypedef struct SCCBcard

From: Alexey Dobriyan <adobriyan@gmail.com>

* struct SCCBcard => struct sccb_card
* PSCCBcard => struct sccb_card *
* SCCBCARD => struct sccb_card

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 14/15] drivers/scsi/FlashPoint.c: Lindent

From: Alexey Dobriyan <adobriyan@gmail.com>

It's much, much more readable now.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
------------------------------------------------------------------------
[PATCH 15/15] drivers/scsi/FlashPoint.c: don't use parenthesis with "return"

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

