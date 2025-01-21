Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D78137C35;
	Tue, 21 Jan 2025 12:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737463607; cv=none; b=YY/YC1i3OrJ0aOhIfU17vnNnBG+7k6VFzBVtfWnKBPAWrQjMTcUO8QauXZpi4q1+mICn8RgH17y5WDS+HXJMBBQoPxem2cHZdV34RI0B5rqIkz2ZvOp/+GrLr1py7luPj5ltmkBe12SZTv/uZnvARY09yTsulymhz7MK6lbDGiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737463607; c=relaxed/simple;
	bh=W9nl3YKnCQDE1X2b5pjXhMCO9oZS7VVd6wSfBGN1WSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESAsFXaD+sHCVbf8Md5gTPctlnsqQtR13P7E2HI4Rtz8VeRlobuoRIy7hCCuVKRHyYGzYY86astbXO7m6cNdEdmZaRo9L/TVmXIvhvuuAXMMUETHsjeVFfeUpCl9tdbziNT/5eevY4FG8oHHvqhTUniV5zeXb6VsGg/bmR71uRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTDLZfwz; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTDLZfwz"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2166360285dso105082055ad.1;
        Tue, 21 Jan 2025 04:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737463605; x=1738068405; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=27Z37WKcrwgjOOi7FlQ+WibXSrhUozysFKFYHxH9euY=;
        b=ZTDLZfwzRGoCO/Jp35P4VuSslGMP1JpxFJwFwFV7G+WR5QhQFVMoD/svT45Q4Kmph4
         z+mLgFIx0pWlqnxxjtsGKJrI7kLcn0LhvB6MwWuCBL6DHGF4JoisDOkFb4pf3U1QYqCo
         flNw1dvMLkCBDxOgwi/9yflwYKQ7nWwDFU1eRp2a+Ja7uVT/HB0M5v8NjyhEB+uifVq3
         3VS/kHPc9X30CobxLD9Db8M4orngyWTW1uPiuqgW00L/aRgO3FOd0Vx4I4Byy3kvudim
         Z9rKVe1U3A2pwKw5ryTWMvstvSIiSkXiCozlkbDKXwPWNuIXhOy6Nyxts35Kqi2cIgcm
         sEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737463605; x=1738068405;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27Z37WKcrwgjOOi7FlQ+WibXSrhUozysFKFYHxH9euY=;
        b=X5edUqosMTyUN1j57Q7sD2EVj8p0YFKomsGwRBuB/ZDyFrvqcefTILaARCwKtb6YmK
         RZ5bp5EBEfOuR5jbxuPhGjvaFfLy+k4l2nEx8+smBBh4lYSl4Vr39HbhKERd5oyMFSuC
         FssY33fO4DsL+UTEbMflVGMGzEVQ+EZ8/SwGPYMsdnvfAPweOYkrEUketJDtzCMB2oRC
         72u44ytiA+RsTWeRPfSh+y+soXuIEPviXGjN/0tFhBHLqUChjZemO70HIvXLyD8tcpxv
         CrKFWcNh3XXvXD+dI3DKEsuua6rylP55AHF0a3fHKPESkrPr8Mlq5sQyjv6R6ceB/JvC
         kcgA==
X-Forwarded-Encrypted: i=1; AJvYcCWgAwnxzpf4HIhNfFAjSM+FGZP4BFjcKGliL4L//WjcM2ty3/aqycwW5qLkfe+AhnZ+d75jCpe875bv2A==@vger.kernel.org, AJvYcCWrz/l8/b50ae2vTB8gVaW7g36x4F5B46NJpwDkGa3VIPowqVRTvZsF1a3B+oCc/9Yj0GRB7hjUcalwJVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiaFnFcbO0WmfGOp5Oa8himPj7uCOJOAPxauJOwTh8EMi+HlNw
	cdHANHSK+rKY1ACfgGq1ezrL0rWj1mBAUwdyWcnetkZbb+9tD5iO
X-Gm-Gg: ASbGncu6w0LCx0QcIg5E7eyFYiBvkxcO3721J0/WjlhBJ3bmDpxGVQ45TOSlSSG+V1J
	e3FI2dxZ7nQSJBGJgvHQkjPzlb3hDdC5d6hWUsGRE9PI0HfP6DAMqkx3h5CFU5aYKJYQkqqkyIa
	G9snp7G0QasJxXJ6MVvUqPZin9i8rLkcQYenbBCnFRZxYRbvZfbHrQwLbtgMB6uoZmQGz5IKfSp
	2C50w6bzSwoUFu8/2u2G4E6ysiHU0IscKSE1CTTbf2xiX8p7CK3PTXMNAxNQiiYdgMkNHPbqWWs
	XoU=
X-Google-Smtp-Source: AGHT+IEJu8gF0PuLd1yQVI32bBnXwn1f0fRetVvu3ql1hu3+9lmUN/9z2Qk/e/dG2PEGNFjw+cIlBg==
X-Received: by 2002:a05:6a20:9190:b0:1e1:a07f:9679 with SMTP id adf61e73a8af0-1eb214650eemr26333195637.4.1737463604726;
        Tue, 21 Jan 2025 04:46:44 -0800 (PST)
Received: from thinkpad ([117.213.98.51])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab9c8e71sm8789952b3a.112.2025.01.21.04.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 04:46:44 -0800 (PST)
Date: Tue, 21 Jan 2025 18:16:38 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	dmitry.baryshkov@linaro.org
Subject: Re: [PATCH v5 3/4] scsi: ufs: core: Introduce a new clock_gating lock
Message-ID: <20250121124638.ess5iqn6weyw6jzg@thinkpad>
References: <20241124070808.194860-1-avri.altman@wdc.com>
 <20241124070808.194860-4-avri.altman@wdc.com>
 <20250121124217.ajerfz3p7iorc2oh@thinkpad>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250121124217.ajerfz3p7iorc2oh@thinkpad>

On Tue, Jan 21, 2025 at 06:12:23PM +0530, Manivannan Sadhasivam wrote:
> + Dmitry
> 

Oops. Missed CCing Dmitry. Added now.

- Mani

> On Sun, Nov 24, 2024 at 09:08:07AM +0200, Avri Altman wrote:
> 
> [...]
> 
> > @@ -9162,7 +9159,6 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
> >  	int ret = 0;
> >  	struct ufs_clk_info *clki;
> >  	struct list_head *head = &hba->clk_list_head;
> > -	unsigned long flags;
> >  	ktime_t start = ktime_get();
> >  	bool clk_state_changed = false;
> >  
> > @@ -9213,11 +9209,10 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
> >  				clk_disable_unprepare(clki->clk);
> >  		}
> >  	} else if (!ret && on) {
> > -		spin_lock_irqsave(hba->host->host_lock, flags);
> > -		hba->clk_gating.state = CLKS_ON;
> > +		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
> 
> This triggers the following lockdep warning on Qualcomm boards as reported by
> Dmitry offline:
> 
> [    4.388838] INFO: trying to register non-static key.
> [    4.395673] The code is fine but needs lockdep annotation, or maybe
> [    4.402118] you didn't initialize this object before use?
> [    4.407673] turning off the locking correctness validator.
> [    4.413334] CPU: 5 UID: 0 PID: 58 Comm: kworker/u32:1 Not tainted 6.12-rc1 #185
> [    4.413343] Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
> [    4.413362] Call trace:
> [    4.413364]  show_stack+0x18/0x24 (C)
> [    4.413374]  dump_stack_lvl+0x90/0xd0
> [    4.413384]  dump_stack+0x18/0x24
> [    4.413392]  register_lock_class+0x498/0x4a8
> [    4.413400]  __lock_acquire+0xb4/0x1b90
> [    4.413406]  lock_acquire+0x114/0x310
> [    4.413413]  _raw_spin_lock_irqsave+0x60/0x88
> [    4.413423]  ufshcd_setup_clocks+0x2c0/0x490
> [    4.413433]  ufshcd_init+0x198/0x10ec
> [    4.413437]  ufshcd_pltfrm_init+0x600/0x7c0
> [    4.413444]  ufs_qcom_probe+0x20/0x58
> [    4.413449]  platform_probe+0x68/0xd8
> [    4.413459]  really_probe+0xbc/0x268
> [    4.413466]  __driver_probe_device+0x78/0x12c
> [    4.413473]  driver_probe_device+0x40/0x11c
> [    4.413481]  __device_attach_driver+0xb8/0xf8
> [    4.413489]  bus_for_each_drv+0x84/0xe4
> [    4.413495]  __device_attach+0xfc/0x18c
> [    4.413502]  device_initial_probe+0x14/0x20
> [    4.413510]  bus_probe_device+0xb0/0xb4
> [    4.413517]  deferred_probe_work_func+0x8c/0xc8
> [    4.413524]  process_scheduled_works+0x250/0x658
> [    4.413534]  worker_thread+0x15c/0x2c8
> [    4.413542]  kthread+0x134/0x200
> [    4.413550]  ret_from_fork+0x10/0x20
> 
> As lockdep found, clk_gating.lock is uninitialized when ufshcd_setup_clocks() is
> called for the first time. I looked into fixing it for a moment, but the overall
> locking for 'clk_gating.state' looks fragile i.e., there are instances where the
> code is not locked at all. So I'm just reporting to you here hoping that you'd
> have some idea to fix it.
> 
> While submitting the fix, please add the following reported by tag:
> 
> Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> 
> - Mani
> 
> -- 
> மணிவண்ணன் சதாசிவம்

-- 
மணிவண்ணன் சதாசிவம்
