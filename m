Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D338B770FB;
	Fri, 16 Aug 2024 07:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794774; cv=none; b=TCCsWm1OJSqyQzscLfGYXBEUJgKqEFiI1Jq1Vq4ck8b+2beW49x0MajrBIqUUSvQmZcEtMe4yXYB6tud6uKHQ128dszLqWi9YjiINfjCr7HSU7FXQPX3V1FXcgN+LDQ9Q1BDlz4K4/EAhrI6VeTJLpjHuhqdyCtp4so0iYJMfoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794774; c=relaxed/simple;
	bh=tfZn2p8RWXsTl4oUausz/H/NOrc1d5GvPHxwW131Bcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWRUj7BAPcnLyVPORrQBetlDzljY48gCfEjJ8iCzfacxGmY4LJMh+4OKHTPl67W/m+5rhSNFqUltn2tObDj/LtWtHW2u4tJthmkYU3OsGa4Te84ubkqvGikwi7jKgFEqHmDwX12RoWFpwxVNhyHbPfLhuswMr/GaUD6petNQLxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eXh16FHM; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eXh16FHM"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-710ce81bf7dso1384604b3a.0;
        Fri, 16 Aug 2024 00:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794772; x=1724399572; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yCqitL2vC4TIDXevMyjj4uRZNh6ztGM5H4Qtombp2RM=;
        b=eXh16FHM+xPFKJ+lb2ZIrnldHi2Nhpil6r4USgqqLGTi8rsBouamXJ0AjJNVbR3eoR
         R3UAVogvmhK2RSS5l+LlWXm+YE8M/NVEVf8oeCeZ9oJJ8VeB2LP/pS4TuhtnJO1IaBkf
         e+I74kZOtD9eF0WiUMHcoT8FAYCmjuJgbc1MEMLWztiJJpURZTyDrGPjbYzJTjh5hug8
         29LluBkIh2GEXpP5ulLId66MLLSnpWPcgANhRLBtm+BVxQnpBuET0mpzBYSHVIuLgZex
         clLCqVi+F0QnLr5DmBOJx6w0aCNFyGSSNyPHIXbF9cRVTK6jjzOdnto5RddasXiAoZ5d
         kkUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794772; x=1724399572;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yCqitL2vC4TIDXevMyjj4uRZNh6ztGM5H4Qtombp2RM=;
        b=OyhQ0ZPKH1yhvoB21Sho59ALJXXVPjVvecZj74GMuNNp78kuqqE8cWokzD8Utqx5Ib
         1zAheg6KRcnqhiEDYkNjePLbfQZ6hhFBR0RCrgMhF2lxQpAu9F9Q28hVAoa3bwFHQXtb
         w6tOfe+EGB887NYEYGEjuEisgM/n9MA3e3DEzg1DtpRMZL1NR60/i4PhVrmfYzKqIunV
         xnib068rpUlFvuKNNIAb9XJZ+53U6ni87Oipg6tqrF8OvVlzRoGIcrmiPawgO81dBJB/
         3UPig1BEKJG6rZ6LI0hjn5vlvf85qWDCJEnka6u/+ZTCrA3IImcB7JM06KU4kGcIKDDp
         DlKw==
X-Forwarded-Encrypted: i=1; AJvYcCU/KLh4xn/+um8Xw53uOKOECONlo4olpK1uZiwphHS0zmtQjHL2oOUmSqu0+pSp0A1WQ30rksm1CQC8RP87A5nODJokadY2nglAwFxG8xLrDBTCLEU+KKNhr+nO3ts7KsURvYjb+B3Bddr2/4iCHXerW3hkSi0RWFF2G9iWbA1XZCiOIc4=
X-Gm-Message-State: AOJu0Yzl4aYj5EiRcNactxUQsbUBuAotPfWOkbMO1fXmZDE2bEZgFub9
	Esfx1Hj0cauLEPH1EFqymb9tcy+14r0IOP2Ji+osg37UKO3YV+7i
X-Google-Smtp-Source: AGHT+IHdnjMLFDrXUew2brTPTbI8QrOzvSdpXJjVxuaYGbaPyCkKr6kIrNP/oBcqOANohn4tjt9yJw==
X-Received: by 2002:a05:6a20:ce48:b0:1c3:ea28:3c0e with SMTP id adf61e73a8af0-1c90502fa13mr2781425637.33.1723794772163;
        Fri, 16 Aug 2024 00:52:52 -0700 (PDT)
Received: from thinkpad ([36.255.17.34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02fa4d5sm20764945ad.41.2024.08.16.00.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:52:51 -0700 (PDT)
Date: Fri, 16 Aug 2024 13:22:44 +0530
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
Message-ID: <20240816075244.sbul4gsaem4skon4@thinkpad>
References: <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <20240809062813.GC2826@thinkpad>
 <421d48b7-4aa7-4202-8b5f-9c60916f6ef6@rock-chips.com>
 <20240810092817.GA147655@thinkpad>
 <3b2617f5-acb1-45c6-993c-33249fd19888@rock-chips.com>
 <20240812041051.GA2861@thinkpad>
 <49659932-5caf-433b-a140-664b61617c43@rock-chips.com>
 <20240812165504.GB6003@thinkpad>
 <b91b18fa-7af0-46c0-a3f7-550676b7a222@rock-chips.com>
 <9fd536a9-b0bf-46a6-92c2-503ea16f7fcd@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fd536a9-b0bf-46a6-92c2-503ea16f7fcd@rock-chips.com>

On Tue, Aug 13, 2024 at 03:22:45PM +0800, Shawn Lin wrote:

[...]

> > > > For runtime PM case, it's the power-domain driver will power down the
> > > > controller and PHY if UFS stack is not active any more（autosuspend）.
> > > > 
> > > > For system PM case, it's the SoC's firmware to cutting of all the power
> > > > for controller/PHY and device.
> > > > 
> > > 
> > > Both cases are not matching the expectations of {rpm/spm}_lvl. So
> > > the platform
> > > (power domain or the firmware) should be fixed. What if the user sets the
> > > {rpm/spm}_lvl to 1? Will the platform power down the controller even
> > > then? If
> > > so, then I'd say that the platform is broken and should be fixed.
> > 
> > Ok, it seems I need to set {rpm/spm}_lvl = 6 if I want platform to power
> > down the controller for ultra power-saving. But I still need to add my
> > own system PM callback in that case to recovery the link first. Do I
> > misunderstand it?
> > 
> > And for the user who sets the rpm/spm level via
> > ufs_sysfs_pm_lvl_store(), I think there is no way to block it currently,
> > except that we need to fix the power-domain driver and Firmware to
> > respect the level and choose correct policy.
> > 
> > 
> > So in summary for what the next step I should to:
> > (1) Set {rpm/spm}_lvl = 6 in host driver to reflect the expectation
> > (2) Add own PM callbacks to recovery the link to meet the expectation
> > (3) Fix the broken behaviour of PD or Firmware to respect the actual
> > desired pm level if user changes the pm level.
> > 
> > 
> 
> Sorry, I misunderstood your comment, so the action should be
> (1) Set {rpm/spm}_lvl = 5 in host driver to reflect the expectation
> (2) Use ufshcd_system_suspend/resume, but keep our own runtime PM
> callbacks as we need a extra step to gate refclk.

Ok.

> (3) Fix the broken behaviour of PD or Firmware to respect the actual
> desired pm level if user changes the pm level.

If you do this, then you don't need (1), don't you?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
