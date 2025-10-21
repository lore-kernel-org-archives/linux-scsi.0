Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EB92877CF;
	Tue, 21 Oct 2025 12:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761050595; cv=pass; b=CcdJyXjfGC2B6zaMOWlORn78YOK8m6V70XWKweKg+G+mHeX/EQsadxQjWKAeBpNTaknn5Gtslnq1VEw+CTIEv5vOCCyRKpNJrU5uh0V1w5Sbhv6LEsxY6D05MZPWDP0PpJ4cyFTU3lVolbPtKvmlMU9T8nAHRtwkOJaw+xPBR+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761050595; c=relaxed/simple;
	bh=fdc2B+UIoakxvkH39MtBFb8/zvKKb8RgNbO6W2qPYuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QfUF+dKAALmPHlUhDBbRhB0gFuHCdW7WL8Dzg/KtAoVbnmu7/IG8U6KZKwaVIRxSA1nF9uaRGdUztyuixyfkibcoXunApCp3T4SG0/TCLhVROaizk28qs92474jUtNO1mLNWzB4t6mxgkS7/fYRV9qA4avI6KmzX25tDLGL16k0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=KcDOWu03; arc=pass smtp.client-ip=81.169.146.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="KcDOWu03"
ARC-Seal: i=1; a=rsa-sha256; t=1761050585; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=LQZeUUXZj4imCioJZdilt2gNQIVCkYSWFa6Xk7stbLxJT/ziFvWVlNLKUkOGjbQEAR
    U1Lxwk3fi8dW2GX/d4THBKEXyO3/JhhxluoPv4IL5239GtESKBW5y2UbtJ1Um+ZwlJwa
    DKEMTgabg6UM0TWgW5VNp2A+P3vOOPQV2qy8fk0zn1xONGUr/lcfdQne7Y2Y6hE6dyXN
    SbFlsKUs4PyQwcRQclydpW5az+3wDNyT+YM+qzkQ/wjwmABGGkDXGNFipTJKo4t8NgiJ
    7WNC/avISpmetAaMYNMqvPibEedRsy232Nvc4/y1UWY7JTv2xayVsgVm4D/5htpQBKiU
    4xcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1761050585;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JSB9KHC34ZCchIqOCq5+HASAxXKjiajaIqMNc11bsdQ=;
    b=d14D5Qs4bDolMs8w7YNL33zNPn3dytb5NQsl9S/cB+7UEDghRO0kOP3ftfQxLbNdhU
    7IWcaLYmIu5T9O1yZddyx3fPVEbQ0xRCiGKIKuT67UmfE9TW/yLv7qL8L+sv8OXl+Hbk
    O/oKd1ecIYwjLEVtCVPRl0puAf/CGF95WDVIndwzgYlwU+AJsonr2KXDoWbUvuNwTc66
    1jJbfkFJE5iM9OjDaAnsKo8CCH9IQLH30SeWW6f0dHFj26cQ8ObaM3VrLr0iqX4zT00L
    JHXr35X7gewEYT/a7J3FfKJBlp/JHDKLtQnTIywXX/dtX/Obsg6QsvZ7jxCb80Zf/E1C
    Giyg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1761050585;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=JSB9KHC34ZCchIqOCq5+HASAxXKjiajaIqMNc11bsdQ=;
    b=KcDOWu034ZMEgz0JhirABWfOvJRz05fIcpmCbMbv5UUnAb8uVSUE1iP0FofwuG8q1K
    MtTkEsW5HF1ysjoFFTKVXIvA/hxLeKyxbfyOZoR8b0o9rRS2jHLTllKqZwbHmIM1C29u
    ++01fq5f6fnqBGe+hIN7OS+BIULCeqx579SGJimD7XehpVnq9TGKipg7BU4lY2XMov+Z
    0vgUpP12gH6/jiY4qVC8/lloDltoDlnT9UzEB4okEab3E7PslnXyXbNXDB37UYpQj3UU
    2esr7iVYYhCeAaPVbqCc3iqp6VLmfTxsWf+daQL0diS4xjS8OsPym6yxeWgCR1EZPSGR
    f0cA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb19LCh5116
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 21 Oct 2025 14:43:05 +0200 (CEST)
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
Subject: [PATCH v5 2/3] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Tue, 21 Oct 2025 14:42:53 +0200
Message-Id: <20251021124254.1120214-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021124254.1120214-1-beanhuo@iokpp.de>
References: <20251021124254.1120214-1-beanhuo@iokpp.de>
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

