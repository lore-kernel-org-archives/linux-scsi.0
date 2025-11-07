Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28FF2E06EF;
	Fri,  7 Nov 2025 23:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762556746; cv=pass; b=ofnbnoC/lhydni/xtURYR0BG1gs5LBfVvtl5cMq7KA04qbyqky/B6S2Vw09juvS0UBvCfmBFLNc9w1fmNJnOqtvZ8IbGAdrcPil1WWySuqL8JGqfUR3BQx0Ekvb1XkPj2FMe5QKFxjwpJBpoJUjS8BlgMAGqqN/eMG1hhUUkL9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762556746; c=relaxed/simple;
	bh=4VP0VoxuU1WjanN31pq6WRGAf86fZSl8C0HU8Gx6hGw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrdtkymMxp+YunOFVmkj09WXlKAqHwgcFctmy+o+ET2+tQjePqXhE/cVTa1HBscADvwQ+RsBabWqVTtdsjBtGUYeX/7regX1N90YbkfNa0VsLKAZ6gMGnpnAszXRJHO5LFu5lilm6XjjVcxhG7My1UtNDsCbzKe6nYLdDTDjGRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=W5KwJe6h; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=9zyeZHi4; arc=pass smtp.client-ip=85.215.255.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="W5KwJe6h";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="9zyeZHi4"
ARC-Seal: i=1; a=rsa-sha256; t=1762556733; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=V06V5FVJXTz12PRqhtVu8Hgvapv7AtvKWxGXHN0xxC3H9kBkVua1PyKY7cU/jixmXf
    mjyaO/IfJaGM1WTTGlQLqOTwQNHcjav2ajBIpFrzUcP1/qrX2w/vpnOp9jcg/Ze3lomL
    c0I79Ol5h0r6UpM2cJVxOgRQOGokvMnpi5K38prUsmQYdRJXtvU/L2zHZecugxyO4Sn+
    cwNnhhkQzDZAZvSivuc1l4iNCb9eMJJJ6AKufycwvje70+dyh7bJ8s6noRVM4WU7XozF
    5MxaHfAG8G2X/ItH5PAqVDrU+IZnNuJY3IP/VEEcJz9ENMeRfkUO7nPMmDn14op0c4w+
    kWng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1762556733;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=tsXJHzfZt/H/3JMg3mtg3cFRvL9N2GF3FO/sMVeQIoU=;
    b=PWCZc8ENzLixoYDJstU7y+qm+vICkOr2OsEvTdBWltrE2YU9VRp4jIcnmzfAnKKLgS
    7dKN7qe6rzaxfFcbALEggi6zO4DRu23F/P/NyCzM7iimrsWt4/leRUGIpz3WbFnkhcuP
    Ra14hMFRTlhYYGTyK0so5ADcz+ByErvBSpipZ5nAIk3khWI7cCeLx/kpznv8H201oEim
    Mc5VX7IwrvMfnWYYw/olbT2W8/TuhNCkxuCHfF78ou+Pl50ciohlurgxdSHyFjzRLCCL
    sN/9V1IAjnK+c40CfyOANR7kCMY7wXVxLVZ7GOpWB/dmgW7r0psd5niUX4DU8XRbSEk/
    QB5g==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1762556733;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=tsXJHzfZt/H/3JMg3mtg3cFRvL9N2GF3FO/sMVeQIoU=;
    b=W5KwJe6hLtfhAQr88T9fErnjNP4pa2e0Si4kTNlJTptN+ZaaHcW68hTFBcwJ+uWibE
    a9KzhxV6iO9XS/cjiD/sOUsRfZ8Y7ATHR3PJo6cjlpcWkzXtBZ7D/35Ab9MVNuwi5AL3
    NDuV+X8LnaPlQJC3Pm+uL8qKA3lqOOQbmM+EQRGBmMn47nCGZEJ4pzYcaXQKXHPixCzU
    rCVGywTxNvjEupLkdiMYThoX2tUBhkTCXBtfSYRo82pZmL9oluPYm50J7V6xyl6anmiX
    x/mYMk2m0AlRbtOFAeKgo+57N50xLgdtowBGl2VSN+8ohfKxcdFQY67871o53fX7z90x
    c8XA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1762556733;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=tsXJHzfZt/H/3JMg3mtg3cFRvL9N2GF3FO/sMVeQIoU=;
    b=9zyeZHi4IqLONr7tl6l19h1GlBNekH+e25Gnr/uLLGIUfpIES1X/RgsG/SgRIUJeYM
    GwuelZVQC9wnLMu5aVBw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCk6IvFmDk3pfNYaBAA9V8VVg9RNybYRrdPP/A="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761A7N5XNXY
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sat, 8 Nov 2025 00:05:33 +0100 (CET)
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
	Avri Altman <avri.altman@sandisk.com>
Subject: [PATCH v7 2/3] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Sat,  8 Nov 2025 00:05:17 +0100
Message-Id: <20251107230518.4060231-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251107230518.4060231-1-beanhuo@iokpp.de>
References: <20251107230518.4060231-1-beanhuo@iokpp.de>
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
index 35ab61aefb72..a5849e0c6c35 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3836,7 +3836,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
+		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.34.1

