Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F0F25CC74;
	Tue, 23 Sep 2025 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758642681; cv=pass; b=qNhtR67TwoliaTXVVD7KsfXNcl2McQ8ieH/2fUGYKXqZ41B9ueXQMOKPZ1LDAbuAA5/1nFjaOkdZSbUd4OA23lzdyPXc7P8YG3oPGkc449rOT/1ABrIpqw8ACu66M09LHWeEY5h+wkVDKCM/sOMaOpfkYiHWKIHF31n60P54A9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758642681; c=relaxed/simple;
	bh=58ojsysFvPaNnj9sdPpwywdliL+WLSYvNAkP9FwIt58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Md5Vcgq3nuorAVYxzX15/pHgt960CzVb0MI9QgYIIJpj1XO+COxfY7lwpqPX0aqSDju5uQ3U3CIGkjA/bHSqkriPCH8lvjRLTmjw2EogX3O6t0v6Fs1v6Ba9w+Tt2V6FRyGZ8J8GzW7LjLsr+kGxrtAJ/anFTVO887hjRahBW7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=GUUEGTlm; arc=pass smtp.client-ip=81.169.146.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="GUUEGTlm"
ARC-Seal: i=1; a=rsa-sha256; t=1758641959; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=mXmE2DEYzaPKrEImY96+pugrCqid+K5CAsCZWlySu/bucf/kNGmkI650SngzgQHn5Y
    Z+E7UcA+MC/lpUUgheZQZTYdQWH0P0ZlGGw+4Fr38TqFAkUTLYX4KdDN8R3QuH9q+eKd
    PQhMvrqA6I4WqyDp074NbFaDDEkd9cgtDNysdHZpzSoI8f2cctUkTBWkKpCNM7p6S33y
    8jt+0XshhMJORkd76QLA3EZUxqEbFirc0ojikfs1QFLgfRaLQczx6vkl7afEpBlQNVcc
    kEEEGzCE0pAraj2+dqv8rn4cZlc2PwmvGM7c9gryymnetRbJ1LUKjN7DBx6yjKAwzsUI
    ntag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1758641959;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=WeENfocnqtAAgNP8w7OEafJmaxgWIsIDh4ZeyeasUqY=;
    b=XXde7krp64AgGN6c9sw4uIjwET0YrV8QbQHDW9XdHDRlk/VgBHOHD4j5lzPqaGh2R9
    Y21zzCawARK9X0BYAHSMj2FPO6tvOFIZJesq6DKwKAX1IAPT3Dn0nAqMOporgnOPIqYP
    A7en+wZwCM59Mn1Jk9rZiT3eKr8YaNVrN+fQZTQNy7UM0dGN/ip5zuo+beH5DgPad16c
    fltyBoSWxDYTxt/bQ5nbjIee1h2bKb7mTZdTyvDPVyS9sSKOw7UHfuNW5B+rOKRAYcYC
    uQmIoFqcv32eHXSXBw1ObsETOgd2ySHupy8XRLG46l5bcybJVtx4EcsQKcIQ8VfDS8JD
    2J6g==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758641959;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=WeENfocnqtAAgNP8w7OEafJmaxgWIsIDh4ZeyeasUqY=;
    b=GUUEGTlml6tXQKR0DfmPXSKwRKHCXhKZX5rZpqknknwZA2+Q5epdaA0OY+pc8V0LNJ
    +gG1DIYj4ULjauEgaK4rogG9e9jAs5uGh+8r1vVfvW44hmH5DfklINYhSz3jRoeDISXx
    VxHKLemOk6Lsh9obu7gaEqlcjc86Sp9+xno1SJpTVX+/5JVwOYjbUnJI1FotUudLFxMl
    hfpDbS/pY5t1HVuO6GJNVILWRJWikLLAc7Mcqj6t8Ig9E09o8BF1wMIkv1PTmPjahJCv
    yQMKmBg8LVEDhpk7XkJpjbLAZwVIKNfQD6XkmqOt1E6NwJyieBr7MphUFVM1wojOuCHd
    Qt2g==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc618NFdI3eR
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 23 Sep 2025 17:39:18 +0200 (CEST)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Tue, 23 Sep 2025 17:39:05 +0200
Message-Id: <20250923153906.1751813-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923153906.1751813-1-beanhuo@iokpp.de>
References: <20250923153906.1751813-1-beanhuo@iokpp.de>
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

