Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9736A33B;
	Fri,  7 Nov 2025 23:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762556739; cv=pass; b=UfZoDrYJFZEbXihOStKPTpqNnBAh5da5TUNrc8HoEmJqO07/l0KTUeGHlSFUsuLYOh0hXF76ugWlQS/D5gYRuk9YKpjIWMzP4XDWzVudOQkl/+SHYLmDxTWzQcEXl4eIMV+2vECJtba0tToiNTjcPgwlF6NX7qjol/rCyaNFy9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762556739; c=relaxed/simple;
	bh=HERjydC7hjmSPxAtbV5QPk9ebxj2IFNWSjMYJNOKI+s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=foGYUcYwGolOk0losHMz6ADf7s0evcfiaHxkIgT0+BtUstR575xW0hkBmVEBmzlDCBrdVaDb1EL7nJ0vxx+75ALlNMnS+ksIxD75JwS21cDFXIxI/UszERqkVr1TY4xiE3r/o4l7BkmwqWo1iTLpF1QuIooSbItNaQxzRXsJRMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Kdq9/bP0; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=UpNdSuIp; arc=pass smtp.client-ip=85.215.255.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Kdq9/bP0";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="UpNdSuIp"
ARC-Seal: i=1; a=rsa-sha256; t=1762556732; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=mlUalYxnZXYn+XinxCbw4vUbALTAunI+hPLoOE/8XoMKNtQStfdN+EBj4K9vp4bL7t
    yzmMOgbkFM44hy45jknbsJFR/w2N32UaihmwC2G4zbKwg9pps/q8KHv011kpV7kj1wK1
    Eextdc8OQYOQ19EfQd/PXlF6JN1uk3LYODVMOEFAtMs6T05XASHEpkk3g+OM5C4siIyR
    6dxPOC6fmn/hWc4jOSdB2o6Fl5nFhjzi2Kn7yJ5THB08iEfnrkuTeRVXhJVRVewY3EKd
    M+k6QM/2LqiLl/tbdWTzwjSbOJEu9V8DK7BD3MO5GYNX/hAx7tVhp7NmybPhXP20fBh+
    PpMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1762556732;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=uotiEQ+QC7NYTRRNNCoNIgCZoNMIJV0bTwBn4JbEs9c=;
    b=L/Bxpo3ySBuFI1S/lu7i/49KJtNx2Yi44Wix6vnqjeUtKBRXK1cg7zgvZ4ZHey1/zJ
    FC0hmMTrX8TnFPLxXX/0n3CBRujaobvZYRW7xoeFqy4YMYB1IQl4k9Whdzr2oIGudtTt
    Bx+kQlKCiAIrYl0/emciftZcRnWGbNyd7VCVOZoOKhzxXeOgVFQz4r0BYcizzhn3J7ey
    GY2Tb224iFmTQL6Ybd0PAwULQQMdGGye6T41iFK3KAyLs1faVc2a9vOtTOkceYnxZJI8
    jeydmiwHBF5GusZw4dOHdZUfCNwScuAyGyy0gRm0/PAWr8m5Rj/wpEYwtOPKjagVk+Ab
    oSGw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1762556732;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=uotiEQ+QC7NYTRRNNCoNIgCZoNMIJV0bTwBn4JbEs9c=;
    b=Kdq9/bP0i1uH5WpVnOUExWanA+EIX7la+dyUi2y4rGhP3bmOSFBVbKLOsApGRaGeLY
    uxIvFWJznPsLWTu0gooZEAAGpd+GG6CPtix7FIcUARbXe8nOlo10+vhQ97NW9s5CghMP
    Q/Cf2ZhT4i7Hq7oNDgDEQLJxkhGkNxaYHUpWxMF47jyvJviDiHcJYHDPg8qpHGoI7t+7
    Dnk5/v15mvdHT6FC6jflBuVOSpp53yeHI0J1AV6pZKov8bWRKPyGZbeo2DtfcOIHyTVd
    c3tkWasYM73KfBdc++ue5RCa3Sf7bx29UVhnoBTFucIY22TIgobsG5v4vdeGxlLTeaKG
    NdKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1762556732;
    s=strato-dkim-0003; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=uotiEQ+QC7NYTRRNNCoNIgCZoNMIJV0bTwBn4JbEs9c=;
    b=UpNdSuIpJY3ZMp0hquhlZRVLMSk2ClhQ9LYC6LRl9UhWJwJL6JriNRfGy4PknwHq8O
    wtnlF67NbRgdORXRZHAA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCk6IvFmDk3pfNYaBAA9V8VVg9RNybYRrdPP/A="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761A7N5WNXW
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sat, 8 Nov 2025 00:05:32 +0100 (CET)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altan@wdc.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org,
	beanhuo@micron.com,
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bean Huo <beanhuo@iokpp.de>
Subject: [PATCH v7 0/3] Add OP-TEE based RPMB driver for UFS devices
Date: Sat,  8 Nov 2025 00:05:15 +0100
Message-Id: <20251107230518.4060231-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

his patch series introduces OP-TEE based RPMB (Replay Protected Memory Block)
support for UFS devices, extending the kernel-level secure storage capabilities
that are currently available for eMMC devices.

Previously, OP-TEE required a userspace supplicant to access RPMB partitions,
which created complex dependencies and reliability issues, especially during
early boot scenarios. Recent work by Linaro has moved core supplicant
functionality directly into the Linux kernel for eMMC devices, eliminating
userspace dependencies and enabling immediate secure storage access. This series
extends the same approach to UFS devices, which are used in enterprise and mobile
applications that require secure storage capabilities.

Benefits:
- Eliminates dependency on userspace supplicant for UFS RPMB access
- Enables early boot secure storage access (e.g., fTPM, secure UEFI variables)
- Provides kernel-level RPMB access as soon as UFS driver is initialized
- Removes complex initramfs dependencies and boot ordering requirements
- Ensures reliable and deterministic secure storage operations
- Supports both built-in and modular fTPM configurations.


 Prerequisites:
  --------------
  This patch series depends on commit 7e8242405b94 ("rpmb: move struct rpmb_frame to
  common header") which has been merged into mainline v6.18-rc2:
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7e8242405b94ceac6db820de7d4fd9318cbc1219

v6 --v7:
      1. Rebased patch.

v5 -- v6:
      1. Added a comment in ufshcd_create_device_id() to warn against modifying the
        device ID format without understanding its impact.

v4 -- v5:
      1. Added helper function ufshcd_create_device_id() to generate unique device
      	 identifier by combining manufacturer ID, specification version, model name,
	 serial number (as hex), device version, and manufacture date.
      2. Added device_id field to struct ufs_dev_info for storing allocated unique device
      	 identifier string.
      3. Modified UFS RPMB driver to use device_id instead of just serial_number for creating
         unique RPMB device identifiers
v3 -- v4:
    1. Replaced patch "scsi: ufs: core: Remove duplicate macro definitions" with
       "scsi: ufs: core: Convert string descriptor format macros to enum" based on
       feedback from Bart Van Assche
    2. Converted SD_ASCII_STD and SD_RAW from boolean macros to enum type for
       improved code readability
    3. Moved ufshcd_read_string_desc() declaration from include/ufs/ufshcd.h to
       drivers/ufs/core/ufshcd-priv.h since it's not exported

v2 -- v3:
    1. Removed patch "rpmb: move rpmb_frame struct and constants to common header". since it
       has been queued in mmc tree, and added a new patch:
       "scsi: ufs: core: Remove duplicate macro definitions"
    2. Incorporated suggestions from Jens
    3. Added check if Advanced RPMB is enabled, if enabled we will not register UFS OP-TEE RPMB.

v1 -- v2:
    1. Added fix tag for patch [2/3]
    2. Incorporated feedback and suggestions from Bart

RFC v1 -- v1:
    1. Added support for all UFS RPMB regions based on https://github.com/OP-TEE/optee_os/issues/7532
    2. Incorporated feedback and suggestions from Bart

Bean Huo (3):
  scsi: ufs: core: Convert string descriptor format macros to enum
  scsi: ufs: core: fix incorrect buffer duplication in
    ufshcd_read_string_desc()
  scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices

 drivers/misc/Kconfig           |   2 +-
 drivers/ufs/core/Makefile      |   1 +
 drivers/ufs/core/ufs-rpmb.c    | 254 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  27 +++-
 drivers/ufs/core/ufshcd.c      |  96 +++++++++++--
 include/ufs/ufs.h              |   5 +
 include/ufs/ufshcd.h           |  12 +-
 7 files changed, 376 insertions(+), 21 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-rpmb.c

-- 
2.34.1

