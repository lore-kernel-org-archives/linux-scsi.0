Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F02857E9;
	Wed,  8 Oct 2025 20:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759955160; cv=pass; b=Lbx0wEAG6nGvNBy+/6aqlTjSq17v/1dnn8MsBeJTgfzvAXKP2oZn91FlPWKQGD8PcbPJuJEPkV7Xv8s1EvLCZDWeYmHnAmi40BdriYUAI5BVXJHspLPOwzr0U3MJl+XiQhUgOb3Sc7squm9Xk7WdTEjQFXRKlZf4ErAc1dKgH7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759955160; c=relaxed/simple;
	bh=UVFs6f1oWX0rO9WCMXjsc+ItaHwF8aGxJfXceJ0qVxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G+KKpf0h4EC+eGTigRepBsQcBlS2pGIJEkzojWftSPTl+Gq41n4fw37yxcgxkRy7DYdoW9Db089rCgsynkAQmzmAFyXdWIa5KjQnnF2B0pP9kmjSUI3NSCE7hJ4+cF5MBb9Ug8eVO40h+rJpC40Cmi60Ak/BeEIpaVfPAEtLy9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=K9gW9MJE; arc=pass smtp.client-ip=81.169.146.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="K9gW9MJE"
ARC-Seal: i=1; a=rsa-sha256; t=1759954797; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=VVyhI/knTnQcMOpg0NuH36yZ2+qTC/Cn5gGEd2JO35KxqZqTF+B1DZGWzC5e1gTGxa
    JTTS7rmQZSaVkiWVOqMOLl6zxVmz7/q1kY6dp3g532S8EjuLZW7aUvBLeavwkd4G/Af+
    lmIYES38jRpi+rJNX9bcXjVOsOKt1jDifP3ca8latdiMDZkJWEllEqSKEMCPcx0twOyZ
    oSH80tsoTCvykg3T4a1spldGNibaiRSiFQwVrOfkgFO4wiS4Ipgq/w6ungRQgE5hRZJo
    tq0Yg/CqPahSVaXs5vvfHBhX4ASbzHyAFWYM+NiWKp4CsgGTaDFoDPDqnY7OuEcceGGp
    NWNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759954797;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=/xSCu8VvynVNMYTUVx5cO9Gp/o/i91VTG9o19OZT4/M=;
    b=KX0duHOnUjDRehiddrmoTj2GVcdrHnQ3TpFs8E29gxOqIOyX/b9uR7bj8GOvdFLiqs
    Ecauw6K+qCDhqifm9y98XjV188H26KWY4iFBnmhbVEJ6mE3w6tyAsMQlD1S4oyY8EDdq
    LH5+PharSNLpkMc8iThaMVbnZw0Gvnp98ZJ0GtnAdXOgQVvnETuF93+l5Ow7icfitAep
    STGMkeMFbF9IfKKuakHNZ0HbUyTn0ngdNtoq4daEKC4SnWojdkz2bqu3VKB4fLunn1Nl
    krcAKN91P92sA+uqvnc2UXElmM1Y5OD5ASywPIpGdJ6Zles5qyMPSUEKhXlKJQeOa9O7
    AAcA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759954797;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=/xSCu8VvynVNMYTUVx5cO9Gp/o/i91VTG9o19OZT4/M=;
    b=K9gW9MJEDEezkC57a/ojY4Sktqjfm8Tw6smdyPg7q//kJU1n8QypaVIxBCxU5ruSkh
    PDT2KDrWIeDwkTJ3X4jeRtnXFjCCk9FtUTcirzWj7co+4N30XOAHiJaT3e3U0GsxZy6n
    vCuxfvMB+ntw8r4Z8Ve4+yDF6GoXVPkj1J5NN30PD4FcXB1+f05xcPAFO/fqsCbM32aj
    0ISq9DalyzGvG/XPqmgXQ6EKHS4JPhYoF7g3QFeZzxyv1FbvIjTCeXMTUnN/vVJY+g3e
    mNRfbr4ALuSUFrxoJ5qWdjZW7GdqawYaCPkKFT3UoKe1+ZHtGi3szVnnV/KsLmxejIeo
    j8Ww==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RX36IbE0bahBk7fQ77Y5cN0Av1YXTvXCMGxpd0="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb198KJu3U1
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Oct 2025 22:19:56 +0200 (CEST)
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
Subject: [PATCH v4 2/3] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Wed,  8 Oct 2025 22:19:19 +0200
Message-Id: <20251008201920.89575-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251008201920.89575-1-beanhuo@iokpp.de>
References: <20251008201920.89575-1-beanhuo@iokpp.de>
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
index 773926b04149..d65169733a69 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3821,7 +3821,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
+		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.34.1

