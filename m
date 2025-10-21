Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AF132ED3B;
	Tue, 21 Oct 2025 12:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761050596; cv=pass; b=JDrydGKMPOe6WnkawOoukDVv3j2fLNjIzEXsNO1HHRkNd8tiSbwf6G8oKaRinHegbmBhgRqC/zFSIj3zYRbkVIM/PgdHT48Rid/0V7bcGlOzoEDl4VstdTqPqigC6D34B/VxfB6idmwsueBbZvswaHR/u/wnK4yZIEyX9uHcoMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761050596; c=relaxed/simple;
	bh=JFplx2YsQO7K7/79S9p6/kUM59z2gy5vyGKGATJNt3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=U5wfxcwJrI/WyRIl+rXVR8mDeikYhlTLVo3LPBqaGxji8Py+t6/yPa6kEeYVaQAfz/5C0zif1VMfptjEu492RCCXCvOKpFKJ1317aLx2cOSybjh8fmyjVTNX5SrcDkfeDe5Qc0LbhNIO7C7F4SfnU5xlFXmfmupc9LEXAg8J9TY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=UlBMAr3r; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="UlBMAr3r"
ARC-Seal: i=1; a=rsa-sha256; t=1761050584; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ROGweOHKUM+vtm7HWbBKrHi+91eCRZSQ70zcNpAPHo2uAT0cVGFchZs+P4tv70F2at
    y73iAYwwerDasDEAd9SkBdRyH94fXGdRpKXpMtLbymdamHyv3TnFgaYPNJodippMPufG
    nQDDhno5iBpEdbwlcmIEENv84nMve7M9KNa123HDp6q+oUPbOqG4lILuLCMWWsfrwgXn
    VB+EQeyEJCcjdx7WYfFHSg+R+W3hMpENaIA5rvSvgBJG23cnNyTAV4d4ydLWhmxbXEsE
    OOoJIWOFtA3z4SNXrJ4VKiX5Et4QSOx1hOnVhMyRhHPoFw80HJt9O5jgeoHzNh4FDB90
    p9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1761050584;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=VpD+9VLUVwYq18hTNtWoDpMdfiJgqdeoLLm6Mns/AYY=;
    b=rsmz4HrngKtEpZPAZ2/vbgsD2Of+6Ry/NOKCPZrzTw0iNC/iA3y8rJGKFXWHbHou9o
    +KUTnhWBa9XNLcPUsurJDyRxzwxiYaiESjUYoPI5Krr6TXd7FlR7mUGUXP4o7rnTxDkm
    EQ9k06Twe5VQeLU4TaAsj0A8rajwIo9oh1AASbYmGcWMqCJPEYTsedoXvCZebUCZP5a+
    7M73lLRGDYk+guqsj22UeYFuE72necB6nfekJdsa8SuJfRMwlxGdQPJ/qgPhXxIgdc6c
    rdsr0/3pkFpkVZ+50cFqgosSi+Ofo+OCpucORoCf7JFDls7mFxwtNhoV/KRHPFIwjDhR
    sEzQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1761050584;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=VpD+9VLUVwYq18hTNtWoDpMdfiJgqdeoLLm6Mns/AYY=;
    b=UlBMAr3rEtiLYGdJIGDqEHZsj1NZciqhByQSNm6icU4isrMQfefylqsvLALAgeAFQW
    ThlLTaqBA4eBrVFMH2m2mK4IJAzh1K41bh3oBNwRGWtFCDRKYyDpXtbPMEjFz1AFoW3w
    xPYh06H9xv4MJu9QtXgngkEhoJ+DOSzLmnm3uDpEznFOUhFmD72wUmCfHyfER1lqa5nF
    Y2sBlzIMlK5ThW0TnE3bk45d96OdFy15duLVqo8DHag7+TAZyPpvhkMAQdfy+jUNXE3Y
    e8V0oKTjppY5WcUltAf0/faxQKNUK5XtFHBAzwXanSdXn/uUe1ZMtiakGX+NAuBiRj47
    c1Fw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb19LCh3112
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 21 Oct 2025 14:43:03 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	avri.altman@sandisk.com,
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
Subject: [PATCH v5 0/3] Add OP-TEE based RPMB driver for UFS devices
Date: Tue, 21 Oct 2025 14:42:51 +0200
Message-Id: <20251021124254.1120214-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

This patch series introduces OP-TEE based RPMB (Replay Protected Memory Block)
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
 drivers/ufs/core/ufshcd.c      |  92 ++++++++++--
 include/ufs/ufs.h              |   5 +
 include/ufs/ufshcd.h           |  12 +-
 7 files changed, 372 insertions(+), 21 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-rpmb.c

-- 
2.34.1

