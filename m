Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041FB3242BC;
	Tue,  2 Dec 2025 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691073; cv=pass; b=OW2MI3nWs7MSX9gcheMoSo9ScO9MdB+yqwfuUYWd35XmbRUWpg8o4sszS4FQl/aUo6Dx3llmQMWs4I5MnyOKcxatG6Yzd74zSDuFs2jmd8CrMT0cGzjkPLR0oRk6VtNbrbvnVqevbMfCzSbcJRCeW2dpinJA9iXGbh7OdpVMI3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691073; c=relaxed/simple;
	bh=CqGcwqvlT3JI5s2aWU4iSsq9geIqD7wtalzAg8TTfHI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=lOaRPYj56SfQh+4IyqhFOD/SoanDAyWtDwlvN/ATYMBsyQHaT2Gg38zWKwu+bF1Cuxyput4e3X6MWv6IXvOdp4VJIcuBcD9DDGGfEdVtnVOPPL9e4gLu5YQ4VBEuDF4x2ujtb5G6zfcnGmI4hM+iy6Pu6DEU3f8r6II9PfCHPbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=CAueKhCN; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=JlK7GPrQ; arc=pass smtp.client-ip=81.169.146.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="CAueKhCN";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="JlK7GPrQ"
ARC-Seal: i=1; a=rsa-sha256; t=1764690707; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=KiXYi9+cQpEtQ0CZ6FuqegfP4AXe/WDaNrfd46RJlPlmNh75QvNv/2jNfkX5SH/7dN
    /JKXC0+OxCkGW2hZISecuzb6zTHjcaooHD2lmJXECR0Ru0MWmoWmqES6M0D4f/eaFyCZ
    baY0pqfFJcXr3anc6mXKjR9SJ1oukAf4ObXbA+xuAoIr4bRi2qEdlIn6472qMRVJuUPp
    J8jLcGBruwfbleQMhd3ZbEZDmKQd3KkuPLjcjvOBgqK3xx5K1gxi3gXjRqqDQikoLsdT
    Zne6cZPhDUQteTLTReYuRmqR6AG7rLXrPIV6g9J0YCjTeiqKMumJBk9T22ihoOzht7Zj
    667w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764690707;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=ZbjDRbLI8AhRyuG66jVB4u9mUy8L4JMG78Ig724DUeA=;
    b=nOv4nojyYtQRMPcd1/0v9YDxwQTU7pfVrDPTJnlQ9bT6Cl1akNA5dJkRfdkWQBS6cn
    RDrzukPzC8YqRXPbff7xMkCCmaWcUGWvL8Q5CK0+ixd8pBRVxY0bRu6wvQ7UDFOLdlao
    dBO9+fHNwVEeDbiR7u1wcZwdj3tMgfgBIEaClDjKnlRl7NN7NNi4dE+Cia47zbSDIfmv
    mpWDGLsIkLDt5RSqi7H1+NHwwwG7jqDnI0rb4lJ4GZCF48yklpsZGu96AT+ymJQxWqlG
    xNFDERlEZU5VXVKiDjH5pHB8GDPuOewAH/o8dRkMok5pVIxV+xVbSeszqcR6l17gP2wN
    J9Tw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764690707;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=ZbjDRbLI8AhRyuG66jVB4u9mUy8L4JMG78Ig724DUeA=;
    b=CAueKhCNAG9RJx8yRgMHxrBv0iuF+EF3crlLqGpA/qb+KOxwV2PPBjehiXtRdWE8O/
    /clKDkPH5UfYuCwC0h7R93NxlnWm5cnlTD804VD+IgfpmwnosEhvm2FZ9myGIWamgmkZ
    QXd8t+OnZ7TThlq2lpyjV3Pg1BlULPTU/kdylofqinvxiv1EMQni1WeUleClAs/nN8Km
    +AyC/Lb748MQGEDDFkql+ENfAUaxWkRCxQKYUeFHOrut8mTHgiV/kekyQc82+WbkHGWe
    lKid2PAj1tjZ2c6vDadQeMEHZJEyxyHNWtiB+YKEXKxMq4//TCp45XCEChf/2Jbo3ICX
    0qtw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764690707;
    s=strato-dkim-0003; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=ZbjDRbLI8AhRyuG66jVB4u9mUy8L4JMG78Ig724DUeA=;
    b=JlK7GPrQ9fMZn+rH1+BLfNtHIhzFq0XLOApqtt/8V3ULykcWPyZ3bRLBObcR3se2qX
    LbaiBEN5zKoDFqNqKSAw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O28+fJYGxVfGu0RAw7GWUjh5vFf1kXr2e9CjbuRlQs4nJC3kjeg=="
Received: from Munilab01-lab..
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761B2FpkIJP
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 2 Dec 2025 16:51:46 +0100 (CET)
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
	jens.wiklander@linaro.org,
	arnd@arndb.de
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v1] scsi: ufs: Fix RPMB link error by reversing Kconfig dependencies
Date: Tue,  2 Dec 2025 16:51:38 +0100
Message-Id: <20251202155138.2607210-1-beanhuo@iokpp.de>
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

When CONFIG_SCSI_UFSHCD=y and CONFIG_RPMB=m, the kernel fails to link
with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove():

ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to `ufs_rpmb_probe'
ld: drivers/ufs/core/ufshcd.c:10505: undefined reference to `ufs_rpmb_remove'

The issue is that RPMB depends on its consumers (MMC, UFS) in Kconfig, which
is backwards. This prevents proper module dependency handling when the library
is modular but consumers are built-in.

Fix by reversing the dependency:
- Remove 'depends on MMC || SCSI_UFSHCD' from RPMB Kconfig
- Add 'depends on RPMB || !RPMB' to SCSI_UFSHCD Kconfig

This allows RPMB to be an independent library while ensuring correct
linking in all module/built-in combinations.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511300443.h7sotuL0-lkp@intel.com/
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Wiklander <jens.wiklander@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/misc/Kconfig | 1 -
 drivers/ufs/Kconfig  | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 9d1de68dee27..d7d41b054b98 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -106,7 +106,6 @@ config PHANTOM
 
 config RPMB
 	tristate "RPMB partition interface"
-	depends on MMC || SCSI_UFSHCD
 	help
 	  Unified RPMB unit interface for RPMB capable devices such as eMMC and
 	  UFS. Provides interface for in-kernel security controllers to access
diff --git a/drivers/ufs/Kconfig b/drivers/ufs/Kconfig
index 90226f72c158..f662e7ce71f1 100644
--- a/drivers/ufs/Kconfig
+++ b/drivers/ufs/Kconfig
@@ -6,6 +6,7 @@
 menuconfig SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller"
 	depends on SCSI && SCSI_DMA
+	depends on RPMB || !RPMB
 	select PM_DEVFREQ
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select NLS
-- 
2.34.1

