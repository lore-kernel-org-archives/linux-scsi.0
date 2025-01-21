Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9FE7462;
	Tue, 21 Jan 2025 12:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737463345; cv=none; b=mwipkTWMJ/jF7hXA75TOe5Gxa5Hgm6GWN7MzSahIT8gdNzbNcS5HCZox/e9N9vwY6/a3LwnV61zrPP6J/pcWPtjk/T50MbvZ+Gd9UX8pGh8NWLgcBdFKJxZd2Pm6Y7xGYnUnvCDMpfDwTJ8fIA7tpmOhQx8JGD1T7bhkMc37kYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737463345; c=relaxed/simple;
	bh=fRzyGwJWFD007YTb0w0/XW8R7up8veUE1wf2G4EI1zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1SlPcOqu9/G8SceasGNDoVk9n8V8kLRQTqd8MksINvg0VlC5Q9MPOiqHV/vuHhen8+OrOXvvPzMKxuIe71w5/Z4rpVls6dlwiE0XQ+Zu/izlpMbvM+dzVsHCrpXuyJ90sxGdqGQVvNQ/Rod67FLJdXl6qBTb5TtQpmS50DflEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxH4oHHz; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxH4oHHz"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ee397a82f6so9932414a91.2;
        Tue, 21 Jan 2025 04:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737463343; x=1738068143; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YB0RPRb7rfBPKJZ1wfMH9s9igQrLIqT+htpdaKFyTCA=;
        b=LxH4oHHzIKe/5NFMvH/lJyfbqrNGiAuRtOG647OPDUE0irCE+C3s03PsGhYFEQ733r
         iKMWykxO5FCjqEubAZHXIv0wfMUAbbUQNYOS9S4uMtDcxDDqMINnssyuFF2agCwPNhVe
         SqrAoSlZd+ghjKdc1HkuTGxglvtwTQklcKU9nFUUWRjySewHOlP5I6pBaZwxkK06i+XT
         v5lXFpuu4naBKSlzn+4oIBqF/6d9zBvkdc9OwYu93VLO1kCvHLOKHJ51TiAutI5JvA6X
         9I6I/D9P4981qTyQ3iQOZqK4CpDIJGXqVCZG6RGm2/X/yunm3seiT1RsLm2iu5ZcwT+w
         1p9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737463343; x=1738068143;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YB0RPRb7rfBPKJZ1wfMH9s9igQrLIqT+htpdaKFyTCA=;
        b=KX+AghO4xzXSIDUIeNnJWLyDd21aw0g9SuNWQFMSX/H7al4zto1Nd8KYjLB6EtUm1A
         AADH0BVy8Vvp2WtUvxfP2INbtuK6zufaKLfyb1okEcUKMozTVYBqv8xLIhWZegAwLvwG
         4gRHUksgOD6kuU9JzuB2EOhMjI2uXOvB+2iwW9HCoq3vKmTTvxHmtMU7cXlO+MuYhGji
         aBtywa1LkTmdQPIKQzvVQH1BkF46DXyMqtMGhjGWMvxzC2s1wEGa2M4nC+jfKe5E69TM
         BxuCiNU9YUS2giVG8xaE0B+K/XHliifTYiFBxZJXzZo45LAoH2nrY86WD5iPC4W6TrE5
         9yfA==
X-Forwarded-Encrypted: i=1; AJvYcCUY9996R2lH+1AP8NYCmPKHyM6f1zhE/cCqYgH2F2GxzIny5ayy4aJbPzcFfbv25wPKNahw3jetVgn2xA==@vger.kernel.org, AJvYcCX7VQKu8weyfNr+otOltTY4mysAhGXXTMUzTq+K9Afw5rTJvFbJiApipx4p3NsW7PSf3cJ8YrTlZwd91Zs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRRD+SPsBN/8SJju3naFMxW5CxqtUBjqfUvGQUWXQl1NPwCU5F
	jijKUPsZgm/x/S+hbYGhVztIs2WMxXkV4jQLFh2lSpNpe8NwKQxR/vqLeA==
X-Gm-Gg: ASbGncv7yAgDWbXqqABSgWBPrkv2cx8DO/FR0cSyeft0Sl1pUsoXgjJ+amvb2XpbvhA
	9+38CfELPxFJ5+5fiOhG7Do3uE+EekmBbUR/caChGGfRK6ePWuTFpgQ4Tf/2CGLN10MXTgkOOZ3
	pnUTeUbRcYHuCbRO4uqzqF6/Qgi0vWkT3HuluhFJUMIzZ8ASU5+hP5hM1pl4MJRrOW9Ty0L/nwP
	YA4g8eX3f6rCynIXhMwib6B0ethvjDf9a6EEXT6KOWHQ7J85ptYDUkv3C8B+z0peBrqWpRZifgZ
	siw=
X-Google-Smtp-Source: AGHT+IH7rnycGkpl3td75wQmzGCOIMbEFl26UjQwufTCbZlwjyGEiDLtD3oOTMD4BWFEKK9e4Fvc+w==
X-Received: by 2002:a17:90b:5483:b0:2ea:b564:4b31 with SMTP id 98e67ed59e1d1-2f782cc014fmr23486044a91.19.1737463343034;
        Tue, 21 Jan 2025 04:42:23 -0800 (PST)
Received: from thinkpad ([117.213.98.51])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f77614d9b0sm10620634a91.18.2025.01.21.04.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 04:42:22 -0800 (PST)
Date: Tue, 21 Jan 2025 18:12:17 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v5 3/4] scsi: ufs: core: Introduce a new clock_gating lock
Message-ID: <20250121124217.ajerfz3p7iorc2oh@thinkpad>
References: <20241124070808.194860-1-avri.altman@wdc.com>
 <20241124070808.194860-4-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241124070808.194860-4-avri.altman@wdc.com>

+ Dmitry

On Sun, Nov 24, 2024 at 09:08:07AM +0200, Avri Altman wrote:

[...]

> @@ -9162,7 +9159,6 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
>  	int ret = 0;
>  	struct ufs_clk_info *clki;
>  	struct list_head *head = &hba->clk_list_head;
> -	unsigned long flags;
>  	ktime_t start = ktime_get();
>  	bool clk_state_changed = false;
>  
> @@ -9213,11 +9209,10 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
>  				clk_disable_unprepare(clki->clk);
>  		}
>  	} else if (!ret && on) {
> -		spin_lock_irqsave(hba->host->host_lock, flags);
> -		hba->clk_gating.state = CLKS_ON;
> +		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)

This triggers the following lockdep warning on Qualcomm boards as reported by
Dmitry offline:

[    4.388838] INFO: trying to register non-static key.
[    4.395673] The code is fine but needs lockdep annotation, or maybe
[    4.402118] you didn't initialize this object before use?
[    4.407673] turning off the locking correctness validator.
[    4.413334] CPU: 5 UID: 0 PID: 58 Comm: kworker/u32:1 Not tainted 6.12-rc1 #185
[    4.413343] Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
[    4.413362] Call trace:
[    4.413364]  show_stack+0x18/0x24 (C)
[    4.413374]  dump_stack_lvl+0x90/0xd0
[    4.413384]  dump_stack+0x18/0x24
[    4.413392]  register_lock_class+0x498/0x4a8
[    4.413400]  __lock_acquire+0xb4/0x1b90
[    4.413406]  lock_acquire+0x114/0x310
[    4.413413]  _raw_spin_lock_irqsave+0x60/0x88
[    4.413423]  ufshcd_setup_clocks+0x2c0/0x490
[    4.413433]  ufshcd_init+0x198/0x10ec
[    4.413437]  ufshcd_pltfrm_init+0x600/0x7c0
[    4.413444]  ufs_qcom_probe+0x20/0x58
[    4.413449]  platform_probe+0x68/0xd8
[    4.413459]  really_probe+0xbc/0x268
[    4.413466]  __driver_probe_device+0x78/0x12c
[    4.413473]  driver_probe_device+0x40/0x11c
[    4.413481]  __device_attach_driver+0xb8/0xf8
[    4.413489]  bus_for_each_drv+0x84/0xe4
[    4.413495]  __device_attach+0xfc/0x18c
[    4.413502]  device_initial_probe+0x14/0x20
[    4.413510]  bus_probe_device+0xb0/0xb4
[    4.413517]  deferred_probe_work_func+0x8c/0xc8
[    4.413524]  process_scheduled_works+0x250/0x658
[    4.413534]  worker_thread+0x15c/0x2c8
[    4.413542]  kthread+0x134/0x200
[    4.413550]  ret_from_fork+0x10/0x20

As lockdep found, clk_gating.lock is uninitialized when ufshcd_setup_clocks() is
called for the first time. I looked into fixing it for a moment, but the overall
locking for 'clk_gating.state' looks fragile i.e., there are instances where the
code is not locked at all. So I'm just reporting to you here hoping that you'd
have some idea to fix it.

While submitting the fix, please add the following reported by tag:

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

- Mani

-- 
மணிவண்ணன் சதாசிவம்
