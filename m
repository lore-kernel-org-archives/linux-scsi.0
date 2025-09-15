Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC421F5825;
	Mon, 15 Sep 2025 21:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757972976; cv=pass; b=my1DNlGvN7C1X1V2G9knpina6UFPSEfwsvMwhG1NPmat1PjhzwrpS6SLQ8bFAMH6jikTNBr5B5SOCbrPFBCQu28uLNG6v3f3lTw5I067hjgLeW/yE71odNworr1n2hvUDXriG0SYwg2dLo4E5Mh/0rIhB5wX4YhiBJvKjdGfFzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757972976; c=relaxed/simple;
	bh=aem3w5dJ8jtSdXRiJkDmPpe0FDO+4ZZBlR/Rti8YPtw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=us3+xjhcayemGdwB6Qf3Gt8Zmn/tcfxU625/SoHYEWP+OjWdhdliFglHCgz99q9tqVmPKVJCYddu2l9y8xrgEu1JX0wpqx34AsGS2z0/Pw4HS8N5YDcr3wkTcuI4A4eREJYczMjrbWQ4WxVTAAH9dTKJmX5tc1Cp3nM98rZplls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=VncFdBPa; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="VncFdBPa"
ARC-Seal: i=1; a=rsa-sha256; t=1757972782; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=RORpRm/yX/Vgx2ww0IzvPvVqSK4co/BWgUKkgnvqKYFkx68IkGWS68pvzzpRp5XWUY
    St1VjgtmduSzslS6EZj/5mFGbvS/9CwiBTK91GfNXuo9IngnUErT4xOZSuHXFMUig4Qj
    LlomNh4EwiSE3X2CYDqYfCEaxCEcfOnUAIyaz4/u/KkPafJT7e606s3tBVn5RqhcvYWQ
    duOw0Eb4q9TdFhS/pOden/bJrRo6v42b8GfDJmNAG1j3Y26PZ5JUVRjAjflLFxiNXj2T
    4o2CBVhYwFpV762Z+xZi7KqPwWxL/2M2DfHYEK3Z4aUDl2FlBLJbg5kPm78cgIaKl7kZ
    KXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1757972782;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=OpG4vBIZIuUMmX6ew05j+tKlXmLkE7t2VjeHBsSWkds=;
    b=eyvBsEA2cNbMk4+aLUKH4rTEpsT/BwRjNR+VtDbw73SNMISjWTMhuKLeJAfqj3i5Ob
    zYo/ID+6G0S/j3rBSgUa/yfUQoIEGFlLEKKvDZsIQGxmRQbDAjoR8sL4fuJGShBjx3k8
    wI51iK8eKE6VGUCdqX0Y9T9/dGqnC1D/Av2rwIBAGZWOU7Ck9NueREYlBCdF8P7C7h+Y
    F2/ALLIsjMf8L8qRfjqIz4YERmTZbgqWCjmfUsBEcP5e7JoewEdw6eXa1+ukXl8MwhQl
    eXZgBwoiXoosm68Tt0PnEgrzapkDKMlzQmSQ26A4P+gbonxZ6Dxe3B7eVi4uFnjC76kE
    W2/Q==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757972782;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=OpG4vBIZIuUMmX6ew05j+tKlXmLkE7t2VjeHBsSWkds=;
    b=VncFdBPa2qRqvt//s9SK1QEYTnxwzWzP5XY+3lANEuTF2hTmyYPWnd+2STU40rCGtN
    UJlRJbKR9eLYknu/M14NWAtpZdhEDnlWXSC1KkfnPrz1tovDSNpI2gYQcZbXPXltBQbj
    6yXqWin87n5SmFWq7ocM+C1thStJl3DW4b7Uz6oN0IqDKTDOnr0tHwQzWA7BQcNk9Sa1
    1H7wmrgjpi7Ft2I0lU94RIHNWNVMqh/OFThGtnRs5Tpa/oGqAomGxfW9WpaKRDtYqQOs
    V0tJfxrrLmOM8RO571O7Tf1ZSTQdnaKrh2wZg+gvHA4xKO4i91H30f/ryQBx80rf05K6
    jy8w==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCg6IWQdI9ZW5fgNTLz+ViCLXbUTDqukxFTraA="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 52.1.2 AUTH)
    with ESMTPSA id z039d318FLkL3HC
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 15 Sep 2025 23:46:21 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org,
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mikebi@micron.com,
	lporzio@micron.com,
	Bean Huo <beanhuo@iokpp.de>
Subject: [RFC PATCH v1 0/2] Add OP-TEE based RPMB driver for UFS devices
Date: Mon, 15 Sep 2025 23:46:12 +0200
Message-Id: <20250915214614.179313-1-beanhuo@iokpp.de>
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

Background:
Previously, OP-TEE required a userspace supplicant to access RPMB partitions,
which created complex dependencies and reliability issues, especially during
early boot scenarios. Recent work by Linaro has moved core supplicant
functionality directly into the Linux kernel for eMMC devices, eliminating
userspace dependencies and enabling immediate secure storage access.

This series extends that same approach to UFS devices, which are becoming
increasingly common in enterprise and mobile applications that require secure
storage capabilities.

Benefits:
- Eliminates dependency on userspace supplicant for UFS RPMB access
- Enables early boot secure storage access (e.g., fTPM, secure UEFI variables)
- Provides kernel-level RPMB access as soon as UFS driver is initialized
- Removes complex initramfs dependencies and boot ordering requirements
- Ensures reliable and deterministic secure storage operations
- Supports both built-in and modular fTPM configurations

The implementation follows the same pattern as the existing eMMC RPMB driver
and currently supports RPMB region0 only. Support for additional UFS RPMB regions
will be added in future versions after updating optee core structure.


Bean Huo (2):
  rpmb: move rpmb_frame struct and constants to common header
  scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices

 drivers/misc/Kconfig           |   2 +-
 drivers/mmc/core/block.c       |  42 --------
 drivers/ufs/core/Makefile      |   1 +
 drivers/ufs/core/ufs-rpmb.c    | 174 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  13 +++
 drivers/ufs/core/ufshcd.c      |  34 +++++--
 include/linux/rpmb.h           |  42 ++++++++
 include/ufs/ufs.h              |   4 +
 include/ufs/ufshcd.h           |   1 +
 9 files changed, 264 insertions(+), 49 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-rpmb.c

-- 
2.34.1

