Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F74189904;
	Mon, 12 Aug 2024 16:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723481715; cv=none; b=KAM1rTRaetRVgcK5v0FcybsG6h/EmuzdS4nAPRdJNFGxxfrl+yFyvk7Aba/YbAil7y0erXm9mFZh1KFA/vOU1jrBWgCTE5cn6V8F2Q3C/Rqk2uz6POCn8eU9DGz2Msi1CZkfAjMucq+ePoHffsrAsCmijQx5zs30DvZmI2U4fH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723481715; c=relaxed/simple;
	bh=w6aiyfWz0YQTyt1Os9A5lro04Smi7PWk9HMlVKZKVOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hDoigjGz+bilXVGok90rASMpdXxcGC0jFoQl2DkURSs23Ku9w+oYWIXwgJLPAaoniY3n54SW3uOyfeY7ywgpuQkzMaDqZC3yyKuXdlXsXSHzd9396PkAgwQQ60O/Ory7n4GUE5o4+x765ATnuUSF2sO201HivXcXjmORyFTEw4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XVKMrOPt; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XVKMrOPt"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70cec4aa1e4so3325167b3a.1;
        Mon, 12 Aug 2024 09:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723481712; x=1724086512; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zG66/eBVG/x3gWkt3ExQFG0ZymJq67sA2nBIpQo8ZVQ=;
        b=XVKMrOPtR39aiZ5EV+qq48Mt1qiSaqODB03ElTV2OrdIpbKuzYgXoj8hYHX2vaI+Dn
         +424rQPtbFXY4f13c7iEYs3xTUtpeqe5aX6j8nhxu9L94BfX2OazjRlJr/DS3kUu8UTS
         kPGbCnB9axx79+lB82yq5019JlX4zcrp8z3jmvkxFh2oJ1eiAGdVzvaYUghAFWYkGu2/
         X3lwKUaurJe6A41NYOSluQCrSHMJsaQxnF9vr/M6GVki/dMaVYtjg7rNH7WlK+AN4xGa
         xQ7p3pkFjWlpHwjDEJ+oigyqBXm/H0Y12i0F0k6emMYixNer1XMOzxLh38OuvmhY+LsB
         lflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723481712; x=1724086512;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zG66/eBVG/x3gWkt3ExQFG0ZymJq67sA2nBIpQo8ZVQ=;
        b=EhymbQodpNOnZr4m0kV+D/vkK9NHkLgZ/09dlVDYl6dKot7l3Kuw8kVYYhbiKjZorE
         /fs4zsnLT2gVBFXQUuxadNHn4/xvC9QOt9T4OQwXsqPqeUs/lVpuncQLhLBG/mxqRcIr
         opoeGsrWnOTpTrzAmpGpdB0If5gXvwTv465xfDMCF7AzQ7cqVY9JmlDwZKCXwKlRsdMx
         5wTsCXjQoOyP8zZ5QrBE+eZgYOkjneAuFgkv2sMudIH40jzSvYsespkDG/BtWiZ6ruHz
         /SgoYsxg4ftrCWc+Gm2oeJu4cfkbU7yxeW7I5o0PrqVAd9+3pzd1XaDTAGykFjkALPXj
         NTtw==
X-Forwarded-Encrypted: i=1; AJvYcCVytd3re+kA0WevdoQbSf8qZ9lqX2G4DuoZt13Qq8Dmnw6esgeogAaBShlQJWAsBR6cmugRAAY4U0vBH1UhWk5T0PXT9s2R/ylggUnBPKLW9i+4LFpSIjGozP5YA8LUjEcm6tvrqvubpgvQlTdBjDtFQR/mg8WnUXHr/sa4NQsGUw1nULk=
X-Gm-Message-State: AOJu0YziJq9uEReubolWTmjqnA6UuU7fst4mtJQerX/ZEdXcpKsVgx4B
	0gwIRIFs1/SBMlr1sDsxIbyDZ50BStP+aF+S2z6gfSUHkqS71J/a
X-Google-Smtp-Source: AGHT+IEBwSf+fodbYhL2oVkAkNVKhy4cVzJR9k8klIravuzNtcXA9eYBt6xvCZZaew69xrl8bF2y6A==
X-Received: by 2002:a05:6a21:168c:b0:1c6:fbc8:670d with SMTP id adf61e73a8af0-1c8d75a27f5mr1413528637.43.1723481712433;
        Mon, 12 Aug 2024 09:55:12 -0700 (PDT)
Received: from thinkpad ([220.158.156.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bbb5e290sm40096655ad.303.2024.08.12.09.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 09:55:12 -0700 (PDT)
Date: Mon, 12 Aug 2024 22:25:04 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/3] scsi: ufs: rockchip: init support for UFS
Message-ID: <20240812165504.GB6003@thinkpad>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <20240809062813.GC2826@thinkpad>
 <421d48b7-4aa7-4202-8b5f-9c60916f6ef6@rock-chips.com>
 <20240810092817.GA147655@thinkpad>
 <3b2617f5-acb1-45c6-993c-33249fd19888@rock-chips.com>
 <20240812041051.GA2861@thinkpad>
 <49659932-5caf-433b-a140-664b61617c43@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49659932-5caf-433b-a140-664b61617c43@rock-chips.com>

On Mon, Aug 12, 2024 at 02:24:31PM +0800, Shawn Lin wrote:
> 在 2024/8/12 12:10, Manivannan Sadhasivam 写道:
> > On Mon, Aug 12, 2024 at 09:28:26AM +0800, Shawn Lin wrote:
> > > JHi Mani,
> > > 
> > > 在 2024/8/10 17:28, Manivannan Sadhasivam 写道:
> > > > On Fri, Aug 09, 2024 at 04:16:41PM +0800, Shawn Lin wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > > > +static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
> > > > > > > +					 enum ufs_notify_change_status status)
> > > > > > > +{
> > > > > > > +	int err = 0;
> > > > > > > +
> > > > > > > +	if (status == PRE_CHANGE) {
> > > > > > > +		int retry_outer = 3;
> > > > > > > +		int retry_inner;
> > > > > > > +start:
> > > > > > > +		if (ufshcd_is_hba_active(hba))
> > > > > > > +			/* change controller state to "reset state" */
> > > > > > > +			ufshcd_hba_stop(hba);
> > > > > > > +
> > > > > > > +		/* UniPro link is disabled at this point */
> > > > > > > +		ufshcd_set_link_off(hba);
> > > > > > > +
> > > > > > > +		/* start controller initialization sequence */
> > > > > > > +		ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
> > > > > > > +
> > > > > > > +		usleep_range(100, 200);
> > > > > > > +
> > > > > > > +		/* wait for the host controller to complete initialization */
> > > > > > > +		retry_inner = 50;
> > > > > > > +		while (!ufshcd_is_hba_active(hba)) {
> > > > > > > +			if (retry_inner) {
> > > > > > > +				retry_inner--;
> > > > > > > +			} else {
> > > > > > > +				dev_err(hba->dev,
> > > > > > > +					"Controller enable failed\n");
> > > > > > > +				if (retry_outer) {
> > > > > > > +					retry_outer--;
> > > > > > > +					goto start;
> > > > > > > +				}
> > > > > > > +				return -EIO;
> > > > > > > +			}
> > > > > > > +			usleep_range(1000, 1100);
> > > > > > > +		}
> > > > > > 
> > > > > > You just duplicated ufshcd_hba_execute_hce() here. Why? This doesn't make sense.
> > > > > 
> > > > > Since we set UFSHCI_QUIRK_BROKEN_HCE, and we also need to do someting
> > > > > which is very similar to ufshcd_hba_execute_hce(), before calling
> > > > > ufshcd_dme_reset(). Similar but not totally the same. I'll try to see if
> > > > > we can export ufshcd_hba_execute_hce() to make full use of it.
> > > > > 
> > > > 
> > > > But you are starting the controller using REG_CONTROLLER_ENABLE. Isn't that
> > > > supposed to be broken if you set UFSHCI_QUIRK_BROKEN_HCE? Or I am
> > > > misunderstanding the quirk?
> > > > 
> > > 
> > > Our controller doesn't work with exiting code, whether setting
> > > UFSHCI_QUIRK_BROKEN_HCE or not.
> > > 
> > 
> > Okay. Then this means you do not need this quirk at all.
> > 
> > > 
> > > For UFSHCI_QUIRK_BROKEN_HCE case, it calls ufshcd_dme_reset（）first,
> > > but we need to set REG_CONTROLLER_ENABLE first.
> > > 
> > > For !UFSHCI_QUIRK_BROKEN_HCE case, namly ufshcd_hba_execute_hce, it
> > > sets REG_CONTROLLER_ENABLE  first but never send DMA_RESET and calls
> > > ufshcd_dme_enable.
> > > 
> > 
> > I don't see where ufshcd_dme_enable() is getting called for
> > !UFSHCI_QUIRK_BROKEN_HCE case.
> > 
> > > So the closet code path is to go through UFSHCI_QUIRK_BROKEN_HCE case,
> > > and set REG_CONTROLLER_ENABLE by adding hce_enable_notify hook.
> > > 
> > 
> > No, that is abusing the quirk. But I'm confused about why your controller wants
> > resetting the unipro stack _after_ enabling the controller? Why can't it be
> > reset before?
> > 
> 
> It can't be. The DME_RESET to reset the unipro stack will be failed
> without enabling REG_CONTROLLER_ENABLE. And the controller does want us
> to reset the unipro stack before other coming UICs.
> 
> So I considered it's a kind of broken HCE case as well. Should I add a
> new quirk or add a new hba_enable hook in ufs_hba_variant_ops? Or just
> use UFSHCI_QUIRK_BROKEN_HCE ?
> 

IMO, you should add a new quirk and use it directly in ufshcd_hba_execute_hce().
But you need to pick the quirk name as per the actual quirky behavior of the
controller.

> > > > > > 
> > > > > > > +	} else { /* POST_CHANGE */
> > > > > > > +		err = ufshcd_vops_phy_initialization(hba);
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	return err;
> > > > > > > +}
> > > > > > > +
> > 
> > [...]
> > 
> > > > > > > +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
> > > > > > > +	SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_suspend, ufs_rockchip_resume)
> > > > > > > +	SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)
> > > > > > 
> > > > > > Why can't you use ufshcd PM ops as like other vendor drivers?
> > > > > 
> > > > > It doesn't work from the test. We have many use case to power down the
> > > > > controller and device, so there is no flow to recovery the link. Only
> > > > > when the first accessing to UFS fails, the ufshcd error handle recovery the
> > > > > link. This is not what we expect.
> > > > > 
> > > > 
> > > > What tests? The existing UFS controller drivers are used in production devices
> > > > and they never had a usecase to invent their own PM callbacks. So if your
> > > > controller is special, then you need to justify it more elaborately. If
> > > > something is missing in ufshcd callbacks, then we can add them.
> > > > 
> > > 
> > > All the register got lost each time as we power down both controller & PHY
> > > and devices in suspend.
> > 
> > Which suspend? runtime or system suspend? I believe system suspend.
> 
> Both.
> 

With {rpm/spm}_lvl = 3, you should not power down the controller.

> > 
> > > So we have to restore the necessary
> > > registers and link. I didn't see where the code recovery the controller
> > > settings in ufshcd_resume, except ufshcd_err_handler（）triggers that.
> > > Am I missing any thing?
> > 
> > Can you explain what is causing the powerdown of the controller and PHY?
> > Because, ufshcd_suspend() just turns off the clocks and regulators (if
> > UFSHCD_CAP_AGGR_POWER_COLLAPSE is set) and spm_lvl 3 set by this driver only
> > puts the device in sleep mode and link in hibern8 state.
> > 
> 
> For runtime PM case, it's the power-domain driver will power down the
> controller and PHY if UFS stack is not active any more（autosuspend）.
> 
> For system PM case, it's the SoC's firmware to cutting of all the power
> for controller/PHY and device.
> 

Both cases are not matching the expectations of {rpm/spm}_lvl. So the platform
(power domain or the firmware) should be fixed. What if the user sets the
{rpm/spm}_lvl to 1? Will the platform power down the controller even then? If
so, then I'd say that the platform is broken and should be fixed.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
