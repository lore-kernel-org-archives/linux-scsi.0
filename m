Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DDD1E4AE;
	Sun, 26 Oct 2025 21:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761514292; cv=pass; b=fcIWpoDoiKwnZda+0hZbUs6KImNN6k8UsD5+SNto0mlzN4MTQkmOvKGfVGQWLG4zEbC2uemtxzF4Dc27Bv4/O7o9T5RABP7tCzqM/p+meF1tWjejj+W38bfNkaYHj7wwixn1jtCqBbbZ8bwQhLDZ2zhaCfLNYgVCm87r4PMd/3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761514292; c=relaxed/simple;
	bh=WTNeCj86qTAkxcCyC2lSwFw3hg2GsPxR+IP66338EoU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=U/+tzfr6pxcUcW39cWovXWOJvodbzQ2TmeUcNLlL5D63/avmaWK/VPoTIBtufe3LimGavFi+g6TTts4zNrVBnePbwuYbecJtWSFYfBibcN+pGrQRiNJrm5FMgn/atAYvYvx9XtoEZYCwriIl1yN3hGaojT87CWRNULpO4HzCi0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ba4eCyp0; arc=pass smtp.client-ip=85.215.255.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ba4eCyp0"
ARC-Seal: i=1; a=rsa-sha256; t=1761513920; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=LUxFQjMWxETUwHzyrWIbv6xr3ZuqfaiPwukmOBWBcJoIb7SDq138Z7ZjQlgKaCKnVE
    wNuBrb7pSBXbIQ6piyrVbJ1Mw1L9snO8qnh5tUE71ZWyWFqWf3bKprdLNYb9qr6JpHPa
    zB3lNb3ArQaR/Fe6weKfCfNVV2OACrRwigMEVGinHt/3xaoibYzIHUMr+zBmbrGFlhyU
    9rDQvW7HU94/jWCuWu9bXiQU+gMrwz+1ylMrVb/Vv3IBX0hFX2XGigUIBITSxZN/Lic8
    8rUxaPgb2ivDs7E3WnWRUS11l6lOF1lkrKz0G4Dn8EQSxwNAS1+Xnu02W2YJUusVgGY6
    Y+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1761513920;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=mrU0erB8pwfCgZC6OHlvwB1oUwIjc0ONNFVjGNrnK14=;
    b=VUN7sTZYiNBtV0MDZK6LHVhAso2Lvj5chLkfVWCqvlSvAq0QgGyLhUmq+eXo7feuGX
    ZB3N9KkQ8+UEg3HSDpZYWP22grNv1KhXxNtxiPfX3cCOWs5pvt93r219byIl5zHbnMwo
    a5nWbmh9xCDIeBLnz6YmYZdJRvj3WhVkarVJoLlLvJSCIsNRsS2ICuEeWoKVpQTCNKcw
    2xoTbQT5L6e1YtUnDRebQlBQJC6g48wbinonF2/N9+GE2L6yI2ovxWw96LjK1jivtC2z
    pQbtyxYFHY6YYwyv8g7oTM0IwWcyxXPYABedHHCpgSLH111TSRHnz4PgpDjZYG6Zp07e
    9GlQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1761513920;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=mrU0erB8pwfCgZC6OHlvwB1oUwIjc0ONNFVjGNrnK14=;
    b=ba4eCyp0lp54NjDcO2gr3OrBq6RCGWfKlXDCEoFjTUk4GlHcP2cXxvuJYV+6/s/qIt
    +aKE4W+IBbUt8LBhqhhlbYYsK/AVOAABf3t/geQg0CabPMpAsImjhkXkT1HZ2tmkefGR
    I8TM+I43E4Y9JGwwAy3PdimDmaV4uTP3jKI14AFrFjz0N1DmZHp2Gem7KbluJW9PdDo8
    9NPinomMAMbAu+xixYG9NcqA9h8OahajqNgZvnM6GYyadJ/dnz/G4Yn/EeIDdLxybz8y
    KCJESlb8iqbRPgDf0ZfB054Mv18dAYnHw3UL5MNT7SOF6giBM0o0GjwlEBRqriH9rMjO
    yGHw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCk6IvFzzg3pKYIOBA3pK3/fXp3o2O7xeGwra8="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb19QLPJSOy
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 26 Oct 2025 22:25:19 +0100 (CET)
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
Subject: [PATCH v6 0/3] Add OP-TEE based RPMB driver for UFS devices
Date: Sun, 26 Oct 2025 22:25:03 +0100
Message-Id: <20251026212506.4136610-1-beanhuo@iokpp.de>
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

