Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C4320B81B;
	Wed,  8 Oct 2025 15:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759935745; cv=pass; b=XG1sre7TyciEhTomCPCbHT4Mg9IWdIO4rBOzCZrPVSteaJQw/o6UXHtRAI7gcRcOsvAu+7RcpKcuh5iel4cai9yZd0lh7RJwK28EeYgMepSiIQAtjYEep5D0VSkZE96wboc+Q7qRF0uh07TMWZetYv5FxuI6BGZbuSu5V1XBclk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759935745; c=relaxed/simple;
	bh=8BYdubcN33XQRMwNL5x11GZOJ9KL7az6VFbYgDGsnJU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Si6/0LfZqIofMChzrh/CSmzpgDm+d4cI7rx2fDbDG/f8AazNyjtoljtTQFNJ7L8ZiejRFidZMnufIa/J5aHUgms/E9EtgrWOoltkLxB2BUFryIGyD7LNESEEmEZUTJPEJLtnpg6z/KEaxd/SxZn7M/kfBXDDYZD9eWKr9SZal4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=a4xm/TU/; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="a4xm/TU/"
ARC-Seal: i=1; a=rsa-sha256; t=1759935548; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=fJ8qvLwFGOH8CzID6kGiQuZgg+ECo7VcpwYSSzKZ8YY5Nhh6N76F9P8zV5F60PZHUr
    iZQdfcsBmnCAeUmhDWcVWKHZmlQEUzAf7KGxKEUDlxGPUVdEAx49T9A+VMDcx3qyL4re
    h16nhwqy0hvUBUgKpBxTscPHJADb5QplEfYyJ1gewBgubmqB+1cnxt4AGopRpHVbrGOg
    TDpJWCuoWQXUTWrWP+QOKOiBKBsYc0onvAYaCq4KzHjNM32AgGAQN5GLlCDmI5lr2bnX
    XP4NNeOfMC6Y6UB0G74WbrlyRps7xWUaDwz6G1vd4+4+ilCrrfQCvLo/BnNAue413KYX
    vB2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759935548;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=pZuTfJt990kgMbXjxTaGe/0IevJB83uAIgP/D8Hi6Rk=;
    b=F3auZ+sRGx8/UDCrDPHW9Zg0Qv/WMv8Pz8tMQIwpUUz3H1uqJ5OPW3Pg41R5jVsxKI
    Va/puzVwqczPwEDkOnOca04hYMGP0hv8IcFPGReD7j7suObYj1bs3NABM0jU2liMY7nj
    dFknW+Bgq0WXBBE4JirDB4YWjnAXyl0oRGlv1GedXifkJyhPIyXIKliMUChKpDlLlSyE
    Dw2GMxsSVNc2mmk+QjzKfpYMpNQnbXIKCBI5HrPa38V88qF1HMLp5AVLdOXMSoYgd1vj
    +zLfkxZlaVk3RhrS8gqPRgdyRP9doRsyHMqQg2W0MyhAZMpwBVxNAyHVBecNH5CWHzt5
    GiNw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759935548;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=pZuTfJt990kgMbXjxTaGe/0IevJB83uAIgP/D8Hi6Rk=;
    b=a4xm/TU/1E8QlvM4vK+LE8EFzCPoxTwQh+WV1qGHUimHgClNiosMugfS4PNWDelzJR
    1aACH6OxrDk61nF/bQ0WYAFZ7ts4lcgwTAoSZ+LkO42UEv+l4i1x30HSCkznf+7imGBg
    52l49OBRCvEDZaOHNCSL1M4WiLihjmmLmd8lI5ryliSVniUKqcrGJSTvVbnYWqVH5Z3a
    Raoqr2eiXdF7tIQtLQG54zRisrC2VXFZtibuNnlPAlLZAlla5jLid46O87FQMAMiFPP0
    yK8G2+jW44n/1I++eIHgrlfZirJ9Gf5BQWnERFoe9U3jINP6+vQJ8lPtLY7aB0ifYRr/
    W85w==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb198Ex72Tc
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Oct 2025 16:59:07 +0200 (CEST)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] Add OP-TEE based RPMB driver for UFS devices
Date: Wed,  8 Oct 2025 16:58:51 +0200
Message-Id: <20251008145854.68510-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

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

v2 -- v3:
	1. Removed patch "rpmb: move rpmb_frame struct and constants to common header". since it
	   has been queued in mmc tree, and add anew patch:
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
  scsi: ufs: core: Remove duplicate macro definitions
  scsi: ufs: core: fix incorrect buffer duplication in
    ufshcd_read_string_desc()
  scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices

 drivers/misc/Kconfig           |   2 +-
 drivers/ufs/core/Makefile      |   1 +
 drivers/ufs/core/ufs-rpmb.c    | 249 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  16 ++-
 drivers/ufs/core/ufshcd.c      |  32 ++++-
 include/ufs/ufs.h              |   4 +
 include/ufs/ufshcd.h           |   8 +-
 7 files changed, 301 insertions(+), 11 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-rpmb.c

-- 
2.34.1

