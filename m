Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E6C35950;
	Sun, 30 Nov 2025 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764515734; cv=pass; b=DODVeolh3YGJHK5Pi4EcMIehNvThVybAVHjDL02QU/LUiEiYEiQJbdu2JY2qucGLzjdI/g1Su7Sy9vz+rHC0bMAWWBb2GZsD7N+ZHfoYWCrj0f4WFW4tVL7mv70cCqIyYdtLz9//f1x7x4XK7pYtBMNaQJmUxKHFfxOfAJ1Usfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764515734; c=relaxed/simple;
	bh=E0546KVmLyOqS+IefRJA0hiOTM3qXcmUwUaPayniWbI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=PWzgis03vKWyk4pKkdz8V3HXs0GcjQisRLLUFzkJe02PP7hfWw9OeuMU7lvpDxSi9VB9ptR0PuwsgVJgQ5HTuuetrcxCHznEdM0kWZH9IfZqORMQOfCZNpRO4y+nfwVQ7Gb8LJPv3mCJHD+RzNElc7GIC5eHgUBsmZSNqPX1G+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=C9A/dWS/; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=/eU93/5U; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="C9A/dWS/";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="/eU93/5U"
ARC-Seal: i=1; a=rsa-sha256; t=1764515717; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=l9nXMupBev9ZcPywEAjWt5PVeYZ4Fd2mi9mnkA//C5+vhqKnpJw26ueLmiDv0eSdEm
    qQRPwZ1q7iieyYg4aO/uvb6lnKWLVyrqOeWVzJYVERdv0RZA2ZxKsxC3jwLrNYXrv+99
    FwiIoXEVPEuxhmtwrtY5uYdHNiVkIm0TpLeYrCPMgyCg9FfQKna6af/5vrdKD5NvyIfU
    FG/U2VNWsglYZsvU4Qzsq3zbUfoXV3OfQ5DvR22nNOHyv4OjYKLINSX/BGWXi9tMNnBk
    edsSNkMob7V7aGLrfOK/IwZo0VozIBfBFA9wI9CdPDubZ5AXARi+BlXlEtMDE++nVJ8e
    Cs4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764515717;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=gV6Cwh5tI7UvTd89q9+EKxUSnCJKEOHLQhrpuGN/XBo=;
    b=mqoAb5tTVBcLKBDfHEVPgjaHI40mvj0yM7QlKa2uL4PGUz4Da3gBRFItGLfb/4YtRz
    LhLKeSHTSsJc+01CvfoScm28HmCZO9INn1LdgSjsQVJtIRc3sZM9O2GCw+GsNRqR3147
    5aqkegULcpuAbWC9FwjoMnUOcWrR3Z8nBbkG8z6PX+Obm+dRm4dqwN3c3xX6I/FEwclF
    RLaWT+Eh1vHJJQlOV+TGT5jeygsrC560PlqYSwrmN2Z2lRig84ABeBF1dCiXEN57Le08
    j0vSEekdtCYgNL64TcCh70rQeaSaDDmURJj4/v8f03+0LSeaSrOarQODw2Q6bAV1YS0b
    PkoA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764515717;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=gV6Cwh5tI7UvTd89q9+EKxUSnCJKEOHLQhrpuGN/XBo=;
    b=C9A/dWS/j4zTwoCzmIdKPKiClO1fs9SHCDj55rjLxC2n034Bg4enUto+GgBEpKLkeA
    4P0jdG/NS+5lNZkmndIGzWMp/eOtXCwBFwTFPpP6Tue1b2uCaX8eGaFIZBL7EwLg/cV8
    +Y+uDu2c+3BLEhl33eRBi39ZIjferPhkhTTpTRmvMeAgqH0UXdprPki99TsOQkEHjmr6
    CqKOYwj88hGzmMHAbe309u8SR98Gr2iaH29IsiSk5EgHSnnnfDyJtlXIqKvB/CETbiXP
    eJdyVyqMDNO9Tn8pLS3B3gOO1Y1bJjwBuom2olSqSAc92DMphshK7KCENegNypVShpNA
    D5LA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764515717;
    s=strato-dkim-0003; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=gV6Cwh5tI7UvTd89q9+EKxUSnCJKEOHLQhrpuGN/XBo=;
    b=/eU93/5U3e04lrCOvdtyT/MuTf07KULOgE0g1oONqqai3+lN4WrN+NKenN3VvG5DqJ
    EkZlYEzwKIaOR6YjPtDg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RKi6IXApygcifwNENBtkgT8DsNNdoznX0VNiaM="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761AUFFG67P
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 30 Nov 2025 16:15:16 +0100 (CET)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@sandisk.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
Date: Sun, 30 Nov 2025 16:15:08 +0100
Message-Id: <20251130151508.3076994-1-beanhuo@iokpp.de>
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

The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates to true when
CONFIG_RPMB=m, causing the header to declare the real function prototypes.
However, the Makefile line:

  ufshcd-core-$(CONFIG_RPMB) += ufs-rpmb.o

only adds ufs-rpmb.o when CONFIG_RPMB=y (builtin), not when CONFIG_RPMB=m.
This results in the functions being called but not linked into the kernel.

Fix this by changing IS_ENABLED() to IS_BUILTIN(), ensuring the real
functions are only declared when ufs-rpmb.o is actually compiled into
ufshcd-core.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511300443.h7sotuL0-lkp@intel.com/
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufshcd-priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 4259f499382f..9bab6aada072 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -438,7 +438,7 @@ static inline u32 ufshcd_mcq_get_sq_head_slot(struct ufs_hw_queue *q)
 	return val / sizeof(struct utp_transfer_req_desc);
 }
 
-#if IS_ENABLED(CONFIG_RPMB)
+#if IS_BUILTIN(CONFIG_RPMB)
 int ufs_rpmb_probe(struct ufs_hba *hba);
 void ufs_rpmb_remove(struct ufs_hba *hba);
 #else
-- 
2.34.1

