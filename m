Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073054;
	b=vW0u7d/psx4MBK1OFqnxUzI/98Dn8CkIiHVHxG+vUgHgOmu/QfDUcWUght26Yiup3M8k
	 VBaMSuDR3VtB1QzY5o6Xdtaq1+127PGxUEogyt+6sAPJMp+r376hF6lJIULUMXbeAviSv
	 ARnf/wV3c/34HRvAaz4z31BjOoqb097N+zAEI5Xor5uicwKkguFBJmFnPus7X5VGha1Mu
	 +DCInFzdoOBOZLOCMvNRyxRHM9/ti4sowvFKMXhUdNHZx9jSk4vT5w3dJMZBBIzyLFnvN
	 DYFVh6lK1/fK1pAmO0MCb80IggQeoO0lpY/797WZ9s+BYZO2gWxIXE/mh50kt63Op/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073054;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UEWw9Ig9iKja9WE8XqeuTcxNBCAVmVPXINNvj1arHKY=;
	b=UqB9WSAPydT4j+5VqomLFuf+Iy9zvQ/nH2eFqS8VONYaNEogGsYPVd5tXA+HP9FldjNT
	 OyfEtofY5rKB7CMy3WSmeFEOMRDfs8hYTBJtwo/1Yo+keKCI3jCbl+MXR9JSb+Tgy7Qm9
	 Z8Cn8vQOmWdfUIFuUrEKxugsyQWb1H7MC6ag4QYQseKGXn4qwrB31nl08viwC9MiKWtJy
	 /r4EVV8ob/vKG3eVpWaeB3vT9V6e4KCNj56ZnF6pR/FkoyF8TQRAnpNQwUX3cei+YMg+X
	 OMNO4PLimGuYdwB4oSAZNliz3UkBBl5Dp9IAv2NiGELgi8LbzaSIvESz3qB+IVoD+cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=vYUacr79;
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C7F60A2633;
	Thu, 19 Nov 2026 07:24:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41C7F60A2633
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=vYUacr79
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=vYUacr79KMejsDRT7Jb+P2Ue+cjwAi7BFFey73gG6Hj5N2VfSV3qcX5lU7jBbkIKKo7Xgoph9PhCB
	 2kThkW5LRhnwv6KS1koHBr0IWzYkw9CNdCv0GiducappH0CBMZ1jV+OQkgnEJxLl+Nlv0dA+AdCpbT
	 zPI6ADT238cAy+bU=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee36afea411397-e72d8;
	Thu, 19 Nov 2026 15:24:05 +0800 (CST)
X-RM-TRANSID:2ee36afea411397-e72d8
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from DESKTOP-3K8GUTQ (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36afea413214-0d3d4;
	Thu, 19 Nov 2026 15:24:05 +0800 (CST)
X-RM-TRANSID:2ee36afea413214-0d3d4
From: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
To: Peter Wang <peter.wang@mediatek.com>
Cc: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>,
	chaotian.jing@mediatek.com,
	chu.stanley@gmail.com,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	stanley.chu@mediatek.com,
	sashiko-bot@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs-mediatek: keep mphy state in sync when va09 disable fails
Date: Thu, 19 Nov 2026 15:24:03 +0800
Message-ID: <20261119072404.101-1-laixiangwu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <359c3c1f4b30aa837011788a847d5c2c1cb3880e.camel@mediatek.com>
References: <359c3c1f4b30aa837011788a847d5c2c1cb3880e.camel@mediatek.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Peter,

thanks for looking at both patches, and for the Reviewed-by on 1/2.

For the record, this replies to "[PATCH v2 2/2] scsi: ufs-mediatek:
keep mphy state in sync when va09 disable fails":

https://lore.kernel.org/all/20261118032015.974-3-laixiangwu@cmss.chinamobile.com/

On Thu, 19 Nov 2026 13:33:01 +0800, Peter Wang wrote:
> If the VA09 regulator_disable fails, could we just restore
> the PHY power state?

Yes, agreed, that is the better fix.  Forcing the state to false
(v2's approach) keeps the enable count of the va09 regulator stuck at
1 - the regulator core drops the consumer count only after a
successful disable - so the next power-on would raise it to 2 and it
never returns to zero: va09 would then never be physically disabled
and the devm-acquired regulator of patch 1/2 would hit
WARN_ON(enable_count) again on release.

Restoring the M-PHY also keeps the suspend error path safe: when the
power-off fails inside ufs_mtk_suspend(), the link is set off and
-EAGAIN is returned, and __ufshcd_wl_suspend() then runs
ufshcd_host_reset_and_restore() without powering the M-PHY back on -
with the state forced to false, that host reset would run against an
unpowered M-PHY.  (The Sashiko AI review of v2 raised both points:
https://lore.kernel.org/all/sashiko-outbox-220026@kernel.org/.)

So v3 drops the forced state clear and restores the power state
instead:

 	} else {
 		phy_power_off(mphy);
 		if (ufs_mtk_is_va09_supported(hba)) {
 			ufs_mtk_va09_pwr_ctrl(res, 0);
 			ret = regulator_disable(host->reg_va09);
 			if (ret) {
 				/*
 				 * The va09 regulator stays enabled, so
 				 * bring the M-PHY back up to keep the
 				 * software state in sync with the
 				 * hardware.
 				 */
 				ufs_mtk_va09_pwr_ctrl(res, 1);
 				phy_power_on(mphy);
 			}
 		}
 	}

mphy_powered_on is then left set, and the next power-off attempt
retries the full sequence, so the enable count stays balanced in the
end.

v3 is out as a new thread, with this change in 2/2 and your
Reviewed-by kept on the unchanged 1/2:

https://lore.kernel.org/all/20261119071611.117-1-laixiangwu@cmss.chinamobile.com/

Best regards,
Xiangwu Lai


