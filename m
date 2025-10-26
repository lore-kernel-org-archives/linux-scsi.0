Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A4721CA02;
	Sun, 26 Oct 2025 21:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761514106; cv=pass; b=OWlqUa70CJARB6GlNgCMKr/P946r3yhkx2rydMEDO5SL0OfgIBuhY0367INAb97qKZax8M6PiWdiBSmwgQhs6XxZS8L2AVm9CnqoGghr8nf6HRIVrSh9awgojjwlhlaz66JMLaqAxWPkB3wPTuxxXuWSii7lsC+sdHXzqNE3+90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761514106; c=relaxed/simple;
	bh=fdc2B+UIoakxvkH39MtBFb8/zvKKb8RgNbO6W2qPYuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z72bH4/ejLsiYUg3Sfo7iPTXwi5HQ4tnxAXOPBnDh9dxVl7bgtp3y71jq7YdiIGTG2SMEZ8jD0Jwv9mgv0tLVSI2HCIuenXGiDguYUF24FocF0KMuuc3O2K0psYW7758izkfGHMvfOvWUkId9ih7gsBKQcFaSAZNn3Mstue7QEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=gXIw5KNA; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="gXIw5KNA"
ARC-Seal: i=1; a=rsa-sha256; t=1761513920; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=S7ruRak6LZoxa1d3lRv+jgpkv5PZcombCqo3RVKkE4Sd9DyPVv1BhzExyIGg6NW7lI
    sQxywsCFAla4JmPf5CQuG9p0GPf9Yub3OEWXhLVXdsygtKI32fhj5i8j7bRsnUpRX+Fj
    dbVrxsBqs5SuTCAaALaJcN7ywqsaLZdV3tv2Q5txoFJj8QB2Di1MdA+4pRyCM52r9+0x
    4QG3BUiJ0AT4SlPrsa9wXomrVW41zkMz/i77HFonVnwqDttckIbq7GFBn4NTb0aYh8Xo
    nbg4c9E77olUJLkZ4lEP7XKVw9c5s/Mvb4ele0QVS3z9feCPqJBDY2BqwordWdz3P7/q
    2nxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1761513920;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JSB9KHC34ZCchIqOCq5+HASAxXKjiajaIqMNc11bsdQ=;
    b=lL/Al/AKSRBn3EVdnRCN+7iV5PQFcU3T6EiUEWCHaFEUnV4E8v1sTtdax4T41cRqRc
    alZAxlo0o7orQ0QBGAm6V6e6TJ60KLyuTwuEi7DBrMjUvlZcUsQNB+wt0bgrQk6XMClV
    J2Qr4al1Pi+k/YRHtGLgFDFHeMEx5RBo1VRTmAfzQDkO07gdAZaYQ/My1lBAiwEZMjDC
    xkzlbhXmkxUT4IZBHy5+ZPUawCyMDZPlSu/iHP2If/YU+DVNLGRRTKaj9988SbnIvJED
    plAmnWZ0vXIXFPadNdyEfVXnNGh3fWjTY08bu+gH/s26MmD8OFaXTViPUGc+7SV+fcT8
    VIuw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1761513920;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JSB9KHC34ZCchIqOCq5+HASAxXKjiajaIqMNc11bsdQ=;
    b=gXIw5KNA6qwv0aRhVd/h0vpVQ+D1342JLselqIu8Nka9t5yc3+iNOTmyVy79yOLbRx
    I8rbP+EfIHjyXbGgH6N59/GAw0Qf0N/Lai8piEGGGWJzhNqD2KS05E4ygbpZT/HMv2JY
    AVbnepfpuET5PC1SSxc9wGkOoLbkopCK2AMY10CnWm0V/PnuuJEyQ3vV6pqh6KGfs+pq
    ksCO5UzHM01OzSX4bdLTbVfXy74RcSH96SkoR8NkvjbhMxTozslizvx5awSfs2C46xI8
    BgykgRkFcpFaMo8ANIyIdCwmxKqtOjxiJat/xDD1pHwXUhnVZ/vI6MKwzSzEA5bNFcwK
    CnRQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCk6IvFzzg3pKYIOBA3pK3/fXp3o2O7xeGwra8="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb19QLPKSP0
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 26 Oct 2025 22:25:20 +0100 (CET)
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
Subject: [PATCH v6 2/3] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Sun, 26 Oct 2025 22:25:05 +0100
Message-Id: <20251026212506.4136610-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251026212506.4136610-1-beanhuo@iokpp.de>
References: <20251026212506.4136610-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

The function ufshcd_read_string_desc() was duplicating memory starting
from the beginning of struct uc_string_id, which included the length
and type fields. As a result, the allocated buffer contained unwanted
metadata in addition to the string itself.

The correct behavior is to duplicate only the Unicode character array in
the structure. Update the code so that only the actual string content is
copied into the new buffer.

Fixes: 5f57704dbcfe ("scsi: ufs: Use kmemdup in ufshcd_read_string_desc()")
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2a653137a9ea..af7f87f27630 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3835,7 +3835,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
+		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.34.1

