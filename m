Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FB1AA1D2;
	Wed,  8 Oct 2025 15:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759935736; cv=pass; b=KQfnBwYBOpKg0/MLNh67dln1Zex1+qFspI9Z3//HezrJN6fB79k/hL4eqcT8dXfrSpc0G0FYUjpfQzQNzsUxXGCHfuWI0xufeVcytLPH6XrvCPp2LbUdg468O42ebdQ7O5TgbEtkrjFJUiO75quTWbNCYdGFM89AGlFwtteh698=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759935736; c=relaxed/simple;
	bh=rDIfWA0GjmrAqzYaHNfIeUzV0LxtUFu+8TFUIiy8UOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSNNaL4l9s9s5AIfg8JNpBI4IKc43d8LTARtzdy7h3i1QIC/SjzoUSNiB+ySVV+1k+OXp80QFUdOKamaP4dlUJaTedpkHRwalawsO3PjswRS4QNvv82Un7oq4S/ofS89HLd9MarUrheMKbyey0LvrT7JbCIlaU6nt4zyk8dUlqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=m81EBU09; arc=pass smtp.client-ip=81.169.146.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="m81EBU09"
ARC-Seal: i=1; a=rsa-sha256; t=1759935548; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=cE9RFA4kMhZYAFDGf0QQzaeZq21BRAccYxk/BZVL9lY1/BYi0hdGS3N0LAUDITmIy3
    gzmcmnZX8wf4hUWUGJj6Qnoe2pZ4bBs9e9Bw5P3eJEz+9Z2mICFrhcngusiyrdWrVOGT
    iNn9J9Iw8bHSaRlwyEB604tDTdHEMFKZm3ln0k7F6UxePDdYSPZCapQGSvofnGGPZyjr
    O01ltKuMW8w0T+XR3uIxOhRaaY8AWDxwmYnZBZ4h2kUE57SxBrJAZRGFjgfm3MJz5Jn6
    GDm6K+cHfkhsAI4cp6E7nSbg9OiOZafKKAEQojZuFHGTdxcbFoGfjawwR6wVGzM0RrTv
    jeKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759935548;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=krhcCaDEBGrRzyaLw1CjLPfRgbcCwT33TM7M7vbW/D8=;
    b=Q8O80fxHk06Ipeu7sGqaIlOIUfcXgYOoDo/X5zd4a5F040P65kF9ffY1NUBfQLRcvT
    0hdSI05jykBeOvwctzYl+KRHUnOlNTM6KjrOkB/SeuUQdntNtlwtt7eqPDp7oZXUqxTE
    wjWyERH7TmF5Iyt0gHuf/4a+rUvp6iBtHL6nQyzGuf03pQeXyfyCUr31s2WGObKPXP2A
    nAfg4qadXnXSDGOSjlFh4lJ7xsrni1Tg79gvs2LdlvKlEbTkngP2YVM+CDUTGrWx1+oC
    warNO7FfmPqtv20wa6HwCPOqROxObEIZDhTTddCTywE4GnNvn2fdiBbfk0oRkQXV0nK3
    G4/Q==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759935548;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=krhcCaDEBGrRzyaLw1CjLPfRgbcCwT33TM7M7vbW/D8=;
    b=m81EBU09DGA6g1ymsIgZMs5V6iYmP/8fPaALfGGQp2v+OG/luWTUnjjIevSAPUmPuT
    Rvpyphvs/GxKIrbvbCuv3CgQym0XUxTGqxmm4DClJJfew2eLdsTlYuPY8qTSdNgIKuty
    54u+eCYXI5hv3fe0OaWPkvCbUUatswc0+w0jmjv26GqEItiORmWMPGPVqv53gWQvO4fT
    IbW3aeWdgXPWrypOO4wlA62ifK43Ry3KjEHVSVYrDDoy/XO0ap0VnpCiJBIcz+C7CoKZ
    EoI30PiBNd207XgSsxZ3+WmhORfEkaDH5oZQDxULVHIQypWnzqRFs1pC/9IZlxzRkzS7
    UYbg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb198Ex82Te
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Oct 2025 16:59:08 +0200 (CEST)
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
	linux-kernel@vger.kernel.org,
	Avri Altman <Avri.Altman@sandisk.com>
Subject: [PATCH v3 1/3] scsi: ufs: core: Remove duplicate macro definitions
Date: Wed,  8 Oct 2025 16:58:52 +0200
Message-Id: <20251008145854.68510-2-beanhuo@iokpp.de>
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

Remove duplicate definitions of SD_ASCII_STD and SD_RAW macros from
ufshcd-priv.h as they are already defined in include/ufs/ufshcd.h.

Suggested-by: Avri Altman <Avri.Altman@sandisk.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufshcd-priv.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index d0a2c963a27d..cadee685eb5e 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -77,9 +77,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd);
 int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 			     struct ufshcd_lrb *lrbp);
-
-#define SD_ASCII_STD true
-#define SD_RAW false
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
-- 
2.34.1

