From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 00/15] drivers/scsi/FlashPoint.c cleanups
Date: Mon, 6 Feb 2006 23:52:04 +0300
Message-ID: <20060206205204.GA7819@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.195]:37021 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964793AbWBFUdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 15:33:51 -0500
Received: by uproxy.gmail.com with SMTP id h2so19524ugf
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2006 12:33:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

The following patches will be sent to Andrew off-list due to sizes of some of
them. They can be found at http://coderock.org/kj/flashpoint/

	001-flashpoint-remove-unused-things.patch
	002-flashpoint-remove-trivial-wrappers.patch
	003-flashpoint-remove-uchar.patch
	004-flashpoint-remove-ushort.patch
	005-flashpoint-remove-uint.patch
	006-flashpoint-remove-ulong.patch
	007-flashpoint-remove-ushort-ptr.patch
	008-flashpoint-use-standard-fixed-size-types.patch
	009-flashpoint-untypedef-struct-sccb.patch
	010-flashpoint-untypedef-struct-sccbmgr-info.patch
	011-flashpoint-untypedef-struct-sccbmgr-tar-info.patch
	012-flashpoint-untypedef-struct-nvraminfo.patch
	013-flashpoint-untypedef-struct-sccbcard.patch
	014-flashpoint-lindent.patch
	015-flashpoint-dont-use-parenthesis-with-return.patch

They were sitting in -kj quite long, reviewed by at least Randy Dunlap and
Domen Puncer, compile-tested with CONFIG_SCSI_OMIT_FLASHPOINT=y and =n.
------------------------------------------------------------------------
[PATCH 01/15] drivers/scsi/FlashPoint.c: remove unused things

* Remove unused #define's
* Remove unused typedefs.
* Remove prototypes for non-existing functions.

[PATCH 02/15] drivers/scsi/FlashPoint.c: remove trivial wrappers

[PATCH 03/15] drivers/scsi/FlashPoint.c: remove UCHAR

[PATCH 04/15] drivers/scsi/FlashPoint.c: remove USHORT

[PATCH 05/15] drivers/scsi/FlashPoint.c: remove UINT

[PATCH 06/15] drivers/scsi/FlashPoint.c: remove ULONG

[PATCH 07/15] drivers/scsi/FlashPoint.c: remove ushort_ptr

[PATCH 08/15] drivers/scsi/FlashPoint.c: use standard fixed size types

[PATCH 09/15] drivers/scsi/FlashPoint.c: untypedef struct _SCCB

* struct _SCCB => struct sccb
* PSCCB => struct sccb *
* SCCB => struct sccb

[PATCH 10/15] drivers/scsi/FlashPoint.c: untypedef struct SCCBMgr_info

* struct SCCBMgr_info => struct sccb_mgr_info
* PSCCBMGR_INFO => struct sccb_mgr_info *
* SCCBMGR_INFO => struct sccb_mgr_info

[PATCH 11/15] drivers/scsi/FlashPoint.c: untypedef struct SCCBMgr_tar_info

* struct SCCBMgr_tar_info => struct sccb_mgr_tar_info
* PSCCBMgr_tar_info => struct sccb_mgr_tar_info *
* SCCBMGR_TAR_INFO => struct sccb_mgr_tar_info

[PATCH 12/15] drivers/scsi/FlashPoint.c: untypedef struct NVRAMInfo

* struct NVRAMInfo => struct nvram_info
* PNVRamInfo => struct nvram_info *
* NVRAMINFO => struct nvram_info

[PATCH 13/15] drivers/scsi/FlashPoint.c: untypedef struct SCCBcard

* struct SCCBcard => struct sccb_card
* PSCCBcard => struct sccb_card *
* SCCBCARD => struct sccb_card

[PATCH 14/15] drivers/scsi/FlashPoint.c: Lindent

It's much, much more readable now.

[PATCH 15/15] drivers/scsi/FlashPoint.c: don't use parenthesis with "return"

