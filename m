Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587102D9485;
	Wed,  1 Oct 2025 06:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759299085; cv=pass; b=p8nk37HXLe6U4GlEOSALdaZtWleUHsqK2jQS472nrLAlRC7WfLeQf4BOlLbIzk8ZMprSK05NIcm6LOJndNdLW8/VA9eXJI2CwzNF+n/BUp2eE/wCmRHEGRJ94u6oFUD54voATUN6skyNDNxwsb/sBWA8dNVbNO38Lqgw4hOHNSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759299085; c=relaxed/simple;
	bh=y0a0WLyhGtAaP/H3DJ18c5oLwvRNpP2gV+sk34yrVis=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phKrvI/OWdMENAiuLNQrjgpUp2HrCaLwC8Rn04Hi2HKJUMT0O2xq3m/t2Bx58nwU/UxJ2hi3X+iBGT+LS5ofw5QjmDJw864gJOTkcjcUxAEp8bhz3dolALL9YRV6vrcwiiODnMBe5j6bAbHuEVot3cvP+X9mqte9ZVo4ed8xOw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=LVMcf67Q; arc=pass smtp.client-ip=81.169.146.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="LVMcf67Q"
ARC-Seal: i=1; a=rsa-sha256; t=1759298899; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=tD42FWj487HHcbih9Fbn0zPmIpXBALCbhE12X2b5ArTbrZCkRC7HakG6ovu6kJXWgP
    nPkezAXjcfgyRPs5yNCCvwVUcSVEpmU0giJ7zqrprry4xkW8f9OmOUInB0DtcA0ofCVD
    yz6lumddpXFqKh3uxDIGSh2yGBNFK2fRCGDey5/ai9eDwiX9wywGPIbjnhczebvi+bpY
    HRY2B3+H1ZGewAdeBa9snlZQaSc3YwTU5QlK5oD6fvMykonWMg57/AfWqDvT4TWghtKe
    nvWsh8srb6TmoDJdnF+3Sagrh/z01UksPxnmsZRboC9DLhYGRDxA59eW7oUwyW7L3lqF
    RLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759298899;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=kcTe3eL3ICiBimw9rIl8MZGWcP9OTJ1LXXZ5Tc5bV2w=;
    b=O3qJoonWwsrKawluSmoF4xE6oMgEN2HAQ5WdiQCCqP72YwQ9JJNizFNvQNDHKzCkn2
    8wTIbktuFlu0O2XNXF9bsAT+Bk6c73uOIW4D5f2rJjkcBjdYgJYfbPE8mOJnuWqIm3+B
    EC6n/bpX5Z9Bz5XWX2u6FL+EjERQbJkL1lksv408ApNtMrdDnUn035Y1ovnVS/hfIXZJ
    q4ouUunnws7uxLo1fqUcTWkgTKgzrPX0JGcJlsf0XMcbjziIqgBG59FKCBuAJ5Ur6l2H
    781PmwXjPyVaE3y4K+IVKl6obTS9AKM95r86zsv7gL0usS4ocB54segCDt0mEJBUFHtX
    7HiA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759298899;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=kcTe3eL3ICiBimw9rIl8MZGWcP9OTJ1LXXZ5Tc5bV2w=;
    b=LVMcf67QT+PLyvKl3DaOZD8oxJBTAQh2QqmmuO4rXBLkzSEDaq9wh9CxOKNpxnbN94
    vECjGBooJ0p4/yF0s+2mvii4QWQXWtmCbxNkz5PQJngOXQHlQlhR7Mz7xYOrtx6aTXYQ
    Cy3YUXg8JHzcMeXpLzM1L3Pm0muvDk3hlon8kqnlIBVnka4ddp3H3bCFW74ZKnCD/s0R
    dMgLfK/vyV6K7fncWUcWRXWJJU0F4Qs2tDM2VFN8rO+UVJ8REb0I/56TDW0GxiiGAzmt
    O5FfqTwM8Ok455JTcSdvzM9Qq484QH8x0pwkay4yT1+7MlBnQOFZGZU/MGk7JTRVADnA
    avxA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2JmZOo2yQsAdmCB+Gw=="
Received: from Munilab01-lab.fritz.box
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc619168IY7I
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 1 Oct 2025 08:08:18 +0200 (CEST)
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
Subject: [PATCH v2 2/3] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Wed,  1 Oct 2025 08:08:04 +0200
Message-Id: <20251001060805.26462-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251001060805.26462-1-beanhuo@iokpp.de>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
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

