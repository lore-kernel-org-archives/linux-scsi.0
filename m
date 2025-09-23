Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090731A23B9;
	Tue, 23 Sep 2025 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641971; cv=pass; b=SjtXBWrypWYjaZxhdJfGBoYMAeLkef44fUAvF3+l3ihN20sjDWnQCdtbn0mqvin4pAz/BEDHYUZIUg/ycuuUKvMVsaapn8Jo2bWykqhWLrhwdKYlX2uI6nh8x+RZHYg+LX26OA8w2q8N0t3i52BJMNxv0RmC022z2EJ5OWu7cec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641971; c=relaxed/simple;
	bh=PXVgZnMVGVyn8qpzM628IQHxXB8vbXCbspuIEiapjkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=rMlIf2MvysTGgq1ZhSKgrKSiONJ6DUHQ86FT4rFppFoDZP+uwztD1xIBfgjQuIFP1ed6d0VdE5a7adBnSRZ/1oCHM8WojXVcy4MXtaPjrxzHVIwCH6D2VeknGVJLenmVCLvbnpG9LzjwstqvHWd3JeCaU9NnBN0B8SlJ7hROXhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=TqiOoWdH; arc=pass smtp.client-ip=85.215.255.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="TqiOoWdH"
ARC-Seal: i=1; a=rsa-sha256; t=1758641958; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=EHa+ZP144zwYWU+fxVOKnCeK8K4FlD3rS2P82ttooY4CorTbUPZBZ4udZClMDjYINU
    JUiBJg4yE8+pDxG9+g3kG1uoZMo0ufwNCqEzyFO3Zp/zC7YfcdUSxuJ2gawNvtIQqE1k
    /RBO2iQIUOA6v9l9SJFgCD3X+EZPU1zLT9SkEmY3tjLrFNAVC1wKkkE5G8PnWpAsljVh
    RnQYD79hSojJMaYK6SYNKfTYDLkPlB0gLSqZvWUjNI0/dmbqtiRE9JrkSCZfcPR7YbNj
    9KFS1QKVuJpabcxX3ujGR+K/otcr3qx9MiRYrKC/rEhBOIu1J4oqikK16bLWo2YwIgok
    OX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1758641958;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=sdyd2ijyYBESfqq2bwwqVjP0qGi8uVwCIVmnAaiChH8=;
    b=ozGGYy4o6C+XnXK/59U+hZFkTE/31cS/WOKvGI7AQnP0Wy9DDYqCveTfm3g0R7KYPE
    kMGmLlqIcSF3yfMhk4MgX4ZOHH4K16QSRojNA/ygT+zhcQGZr2LoTATE2czMzMlzYq/U
    CsLF8YN5/J0hVJCtdyIwX3wNqi+vxMPLbJklrfy46Gjg+zSncmoIX2Hd3JK8rTmGhywk
    ZIx0aAVVEww4rxy1HVDwGYBu4TpAWSoZbvcHJRj9c7QeNgznl2LSclX2viU/N++2s5KJ
    fWf/Ud1eFfhyuUgV8tOZ4g2Ct/mWzujET40cf+GQ8enms0Onn8c126r4TYDIxERa4J3r
    mQgA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758641958;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=sdyd2ijyYBESfqq2bwwqVjP0qGi8uVwCIVmnAaiChH8=;
    b=TqiOoWdHuhpAAQs0lA8P1960Wgcol43yxKHKPutfo8V2X1KYrKQq+icj2TMxMJBHjq
    bSx4d0sh6JUR87Ys5BBcej+qhVsOWEqZwoX9xRvZgzeW8+GFykcgy9nya53YiFrQ5OGM
    hrHdnkt5feU8hWKTHm1wdery+iJ8A/vtD8yA0LykwqImrv3/L1TufkWGx7zUScAeoaOb
    6jS/Sr5srj1qdcgeUkxFxiiWQBc5g7UsRDhsF+hmyAuF76NRUPd2vUV9FOIvVgEN1UHQ
    YShDvYQ3jo3z5fKkGqzm8jzzIrQ1ZoxM9Bq3f9MS3YAsE/iNU+meqUJqxsS/HrolCdM7
    VBQA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc618NFdH3eN
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 23 Sep 2025 17:39:17 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
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
Subject: [PATCH v1 0/3] Add OP-TEE based RPMB driver for UFS devices
Date: Tue, 23 Sep 2025 17:39:03 +0200
Message-Id: <20250923153906.1751813-1-beanhuo@iokpp.de>
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
- Supports both built-in and modular fTPM configurations.


RFC v1 -- v1:
        1. Added support for all UFS RPMB regions based on https://github.com/OP-TEE/optee_os/issues/7532
        2. Incorporated feedback and suggestions from Bart.

Bean Huo (3):
  rpmb: move rpmb_frame struct and constants to common header
  scsi: ufs: core: fix incorrect buffer duplication in
    ufshcd_read_string_desc()
  scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices

 drivers/misc/Kconfig           |   2 +-
 drivers/mmc/core/block.c       |  42 ------
 drivers/ufs/core/Makefile      |   1 +
 drivers/ufs/core/ufs-rpmb.c    | 259 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  13 ++
 drivers/ufs/core/ufshcd.c      |  32 +++-
 include/linux/rpmb.h           |  44 ++++++
 include/ufs/ufs.h              |   7 +
 include/ufs/ufshcd.h           |   3 +
 9 files changed, 355 insertions(+), 48 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-rpmb.c

-- 
2.34.1

