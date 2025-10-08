Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17EC1AA1D2;
	Wed,  8 Oct 2025 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759935915; cv=pass; b=j3FWN28/UZeWec6QyVtgzKngDjOSQinAYWatXTOKA7xZNIGXf/eql/OU+fY8qkh1HGG+XDIGfa565Ey9CNIy7BTuT/KjIe26XBed47SEdcT9zNbZwXjCVDBOKz9Rt9EMGm1/f6AmpWJyd9j6Lh36NECKDzbZLgByw9/NZ9KMpDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759935915; c=relaxed/simple;
	bh=EW8R3PGwU2ywdbrcvYkyavqowdbwUHSEkch1ThA0QOI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QunzYqg/k4/7PvCRfaPXk0Ttv0zeX44od8p4vOFX2RwCRD3tYA488lI5o+xAqhQ08i2++NCLFQ9JjLF2PNvjYia8azYUeUfSZaLNxv5JCyCN0FMcCoWmySD2uPqZ4Ecq7LmgVA1FS9lpRW0Da9nZ8FcnR2N4JPC/1W1qZcBz2gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=VC/nwP0b; arc=pass smtp.client-ip=81.169.146.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="VC/nwP0b"
ARC-Seal: i=1; a=rsa-sha256; t=1759935549; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=d8Khem4UmKn+wduoh9GU9MWe9Gs6VpS+RWrsFgsGeT27SJZ3XcopZTlAxZEHpcCiya
    bfi0M//o8QxOlUesUvISKG+yUI7OdTTmnkDksnpMcGAE/BPmEcJa8kgS1psm3NAjcigc
    LBvJ8PyYBgqDD/dhf5JZxZCtYUAnp0Y6bKi1UZnN0S+Uen//K+2e2KuwE8zzP7dx0vY4
    YGywgimF8Mh2YygW0NnPIRdOcdLXz9tpk4yTUsTjZO2Ud0UlUrAumQPgx7nr0kGGU23O
    elQtl5Q65HZyOYReYIJUIAp3R8EjChIn94RpBtT3W0DfcvjhyHh0lJccoH8xK3+NK8B0
    kQbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759935549;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=gnYEC5iu1A7kycLvhBP+UswZjufkKOz7lGn1felAzeg=;
    b=IKFZEXqeSWBSf2ZMlMGP0JZdR4KpCF7mzkFdk4VU57PyA9Kxq35lhHuV4QsEF3yyPw
    7GPnD7UrlIjSVBk472VaOlv4Zkj0ZjWp5dawLGtvp8ueSu6PtGOCh7WTP+JiAY13SrE/
    CRFf38InsdLRx9/C0M6czefztqlBoMkg+EhFcgnvqZjaz12ZszxfhNvxkEGty7qe3tSS
    MLBRvwtCy//EED6bVLIMpdsxUgctyyxQiFZP5OClzrXVcl5LTqsSDikIcpYjnbjKagkA
    9Vp6ZTrMC3LtI8ACjBaQcYKvEH5f1sj5ZdHGIBFNoy6TJisRCa3igJ5aDakxcf5CbKZR
    irLQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759935549;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=gnYEC5iu1A7kycLvhBP+UswZjufkKOz7lGn1felAzeg=;
    b=VC/nwP0b5rK/aAtaAlVIaVSIq7rpmHtKvBY/uVHbBsADBDpIL5eijC1DKC8Ed6hVCk
    u8kBtF2kfNdZYvga2fr3oKAUV+dtO4D9+8MtEceNXZEaQOweWScMYCMG6/IEb8nQxRtA
    BhlAI7zDx7pElIN7dmxDS6icNeFJB1V5MlWOZMLpxmTpPVrHZcz4IFAksMoaiAInmNjb
    DhSKP4pr7ejZ5Tmf0X+FLu6tHUDd2VEhKdDqqqYuDG+Bgbyckr1m0d2yXNMIBKd80t9Y
    XyRFIaXaasXENN58JK8sMgJon8B2K1noPc+yB7ZF/Te7Q7ZwkTwYwn6bc4j3RJsKElta
    tJ+Q==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb198Ex92Tf
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Oct 2025 16:59:09 +0200 (CEST)
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
Subject: [PATCH v3 2/3] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Wed,  8 Oct 2025 16:58:53 +0200
Message-Id: <20251008145854.68510-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251008145854.68510-1-beanhuo@iokpp.de>
References: <20251008145854.68510-1-beanhuo@iokpp.de>
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
index 2e1fa8cf83f5..79c7588be28a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3823,7 +3823,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
+		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.34.1

