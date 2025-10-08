Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D515728E579;
	Wed,  8 Oct 2025 20:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759954808; cv=pass; b=OaCl6T7tm6WF7bGXrDPkQUTaZGwwcGEtAHzQGNBJ8kYJHcIkIDeOLL/sKoHx0VGLaD/yQV1wGMo0qGRV57bReD74prBq4t05ju8qfI7UUJE9AphHC90YyE902ZTmTRYwIBrtnro/KrU3Hrarv2h5FNMCeanVN55RMWbmw107P2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759954808; c=relaxed/simple;
	bh=Wu8UVCYXlK3TtapPadzpanl3pcuceOvJ0JDnPqiN1Zs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=VADcRofAMW/fJ0Gwgoa3tonlADyKm+cpTq/O/j1sLbKunIyni3Hb3pHA6+fB35+g4NGWfMO86YM5yKlPYa+aDQWH5d7fHhEkf3MFwBMg6Of3iI5Fyd1aiSA8zvz6vL6q5AE3f8gEqJ5HgqmvqA4GXuE/o9Rx83D5rKt9tTFhLqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Cm6Uv/kS; arc=pass smtp.client-ip=85.215.255.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Cm6Uv/kS"
ARC-Seal: i=1; a=rsa-sha256; t=1759954796; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ac4rEXPgl+LVhAC0v/TY0LtKTEpGkpIvQY+wJ+dNZLM4wZSRDSlanUlCQWSsXVi38M
    VLotoTysOTwvK7mw9Suso5BUZBsnAKtjB4RavpUF43zX6awxdU9MwCR5NtGC4hFRaSwP
    pyanckasVNG9sLcTGIo0xN4NkzZgqyjXPGeG/wGSobRcFYCFUkKAS0FgXN8wjr6NHDAW
    3ptePr9UroFdZi1BSNlZjTZ/LX4QJp9yvo6o3oU4oJSuBWblNPUttRxZypy4liWF9daL
    UyQaAZMJPhIrK3u9LAdshH/mgDMyJ2S0F5VbtccCmRQS6vGR+jf6sa4WerGCfFsBYN9j
    tr2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759954796;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=tlm2BgO1wb7weN1i2EzSMXR8kPH0yzp2XFdQ6GUhOxs=;
    b=pECXER553I/LLUDju11LHiAuc+r7CW34/tmvkuF28/bjqZ0eEPfn+zba//gUC7XRjP
    O0dT0+kz/s1ACr3hTvbCZQ2qDo/YWCUokYF/+4aHresg7UH/26YaHUPxRWcAlRv9jcvb
    X6PQzR3L3Xzcg56g5iXVf5wQJR4yGxy4Ism5EHe3wxS6od8COBjyEUObZzwrOwhE8tJ1
    XWtZyG/ppbWTb4WdG9mZNFK2/C5N+SGoFt6jPJG6yADkP4tKGSgp379z/ly7sHK6Vjlj
    qC9sSG9PBOBXgtUJ8DhZnxAE+WcaCJdfjmzm4hHYg7ta9s6Rpk4AhWn54AJmla1U8eZO
    c2rQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759954796;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=tlm2BgO1wb7weN1i2EzSMXR8kPH0yzp2XFdQ6GUhOxs=;
    b=Cm6Uv/kScjHx3E9BAf2zYECPsGY3VqJTbMaIQYQ8dLmckJdmJCVvqhmY8750ojI9cf
    6GjWQuZx7ZQ+3F7ZcQTfEVDZYjlNIiSvuWf9YHA6vqXJLOjjqhypJaP5T0dkYJ+xrwO1
    bxjzGbEk9foIGlW0rW7q35aSYScsTGYhbqFxGSEoyoC3CJWT9cXj1rcZPnN4+aqqoC+L
    HCiyiyQJWvle0aAvmXRjUQlqwcbv/hG1tQ1U3Tw3uwsy524t80E3Y+mGHPf1fa337AvO
    xx8MXI5YrqqkzxmWYUhu3hokA4l36i5Mq+33IBqad7laNlykD6ZJKvLhbGHmeTrMRkyO
    UEAw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RX36IbE0bahBk7fQ77Y5cN0Av1YXTvXCMGxpd0="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb198KJt3Tz
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Oct 2025 22:19:55 +0200 (CEST)
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
Subject: [PATCH v4 0/3] Add OP-TEE based RPMB driver for UFS devices
Date: Wed,  8 Oct 2025 22:19:17 +0200
Message-Id: <20251008201920.89575-1-beanhuo@iokpp.de>
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
 drivers/ufs/core/ufs-rpmb.c    | 249 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  27 +++-
 drivers/ufs/core/ufshcd.c      |  40 ++++--
 include/ufs/ufs.h              |   4 +
 include/ufs/ufshcd.h           |  12 +-
 7 files changed, 314 insertions(+), 21 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-rpmb.c

-- 
2.34.1

