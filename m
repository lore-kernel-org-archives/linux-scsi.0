Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66DB1B3948;
	Fri, 24 Jan 2025 12:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737720201; cv=none; b=I0azikpU6ntKqVDVXLebF/LQtXgSaioBwosOC6CZA1TOQZ/UJLZiqbstmfFqde5tvFyH0+udx2/0qsuZ/4HF8WgjPnpHdU28PEXni09KxzYHVzsj3zEwcnu6Ktw8WLk3q+ZeNMO3BlUfX23HKhuKl8OYnlao2T4iOROETmrlq8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737720201; c=relaxed/simple;
	bh=tYMwFdnXPugYyr74UA8BLZ8Fy+S0LiZPbp6imEOfTgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q20avqJWm7KDaGMr7/506DIscZGU/LT8raOZCCEWvTS3StYIiCQbOuZGNbakdOOdyBU6ojWRirkhgTeaJ9Rv8EbgKe0oXyB6H+NGkp8MwBcc5mYz1ZUvTEshSrNgQ/TG8ggq8f5316M7gpiet4h0jLRPGarHfZ58sYHUmFz1iH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e1a36b3684so25594586d6.1;
        Fri, 24 Jan 2025 04:03:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737720196; x=1738324996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gCiyCFADRxxHja2Qm5J0xPVv7NJyy0ozMIMA67Q/PkA=;
        b=jgU9QFeSJlvCrrTnt3QAP3Dh7EdRAING6k1Y4LCch21mNZAOMXAm0DfzJUdzuMj8lS
         TfJE8A7YvsVpWRyF7upLjsJl1qFASpqV7upijkm1oD/0DXJZ6db9sUPIVwyuyRBEGF7U
         KSG4Q1/kPG0aDvcBOaRDf4j8WRPggZMc0DP4tJYG2eYzFoE9lj8PQynpNGj7lU4XYQh4
         wF0fLFZALXwrabHzbXgvHgryD0sRX8d5UjUqMIAlPCw5Bi6PKnXxCUzrkmKFSgegIJhe
         9qa40/5OvZRkZkgXoIIVx8DNxOWmF01jekGaq8lUoyiuj9UThE7z/EWi/NeYvJQpnnMR
         MJ8g==
X-Forwarded-Encrypted: i=1; AJvYcCWBqobRpP9IQ6GKnpiCk6dsz6vsHAwLsQA+anMX0Zp/B79XtNN0qQMGiJ7m5gjYfs2ltlJgU3KNYQav1+w=@vger.kernel.org, AJvYcCXtPkjaNyMeb05vm7mvRhxVppmTHi8R5+RMck1///SJtmPHL2w/zqnVSWEyw6h2WF+1yjeYl6c+JPz3qA==@vger.kernel.org
X-Gm-Message-State: AOJu0YydX8/VEzrHmvcNnPHyVe01cp8boq5R9v2ewJF2gj+zdaEFWcfb
	17TUIwwq5PTH4+BxeJal+wtg8/mSXBfiwQD/7zyfESH6/e0M7GogRQ1GCsrt
X-Gm-Gg: ASbGncvm5tD96mKucBTcOiWS2oOGhNGS9xwdlEBBnCgh7gm4Inw5yUPY9391tr0qNjd
	L+N9V4otz+iVLW1pwxjQdnXL4mxgkOU2n9sbk9iHPwLxuOIkJX84e3W5i+U2Mr0gcM9YmMI81Dp
	qwN4duLowo5K/f+d+rRUQlCgRPupSXSmN8OOo1h8gYGZdQeNC2oZpEhAKhsTCEM1jIhuxpQL/X2
	Ww9Q4pidoXS10nBuZRwmft2+RTdG2Zdrw2UHvNGQDaBMPgQ+4CqVh5vSyH1RRvahn3uAcjoS3hq
	1eVSVJGpQcbAI2SYj2SV/5PQgjAQtGTW9L9oVYY80d2s7EI=
X-Google-Smtp-Source: AGHT+IEsxboK3vJQ80/xRQA/zvZpJCjZDYaxvnkImUMgUEDXYRc2/Jp+k7Gv4GFqHZ78xBs3R5ykPw==
X-Received: by 2002:a05:6214:2401:b0:6d8:a32e:8430 with SMTP id 6a1803df08f44-6e1b216983emr496395286d6.8.1737720196202;
        Fri, 24 Jan 2025 04:03:16 -0800 (PST)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com. [209.85.222.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e208f826a9sm4685896d6.100.2025.01.24.04.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 04:03:15 -0800 (PST)
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7b6ea711805so266403485a.1;
        Fri, 24 Jan 2025 04:03:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUZq3SW+4Aj7Eg2pohWdb7WD2+Vzw5Etvy4ChyhHCvACd+zE2Ng19vy5Py9i9j6wypMOJY+FsIbZWtNS/Y=@vger.kernel.org, AJvYcCXurwTec/3gtCU6YfRXTwo+UWQ77a4KbqFY3TViNZQgn9b7n8l0VAYQ0WNqHjsQ72uwLCv3laiYC+17hQ==@vger.kernel.org
X-Received: by 2002:a05:620a:424d:b0:7b6:d252:b4e4 with SMTP id
 af79cd13be357-7be63253dfdmr5137840785a.53.1737720195703; Fri, 24 Jan 2025
 04:03:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124073354.3814674-1-avri.altman@wdc.com>
In-Reply-To: <20250124073354.3814674-1-avri.altman@wdc.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 24 Jan 2025 13:03:04 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVHMH8=i3v=qYGhR5t+mbz07TyS7b=6OnnxmHox58c7Eg@mail.gmail.com>
X-Gm-Features: AWEUYZlmyh4mvPt4uR_O6TX7XKEAyBX3agBo1w9YaOuwj69RRobFEzF5vjlgrpE
Message-ID: <CAMuHMdVHMH8=i3v=qYGhR5t+mbz07TyS7b=6OnnxmHox58c7Eg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>, Bart Van Assche <bvanassche@acm.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Avri,

On Fri, Jan 24, 2025 at 8:36=E2=80=AFAM Avri Altman <avri.altman@wdc.com> w=
rote:
> This commit addresses a lockdep warning triggered by the use of the
> clk_gating.lock before it is properly initialized. The warning is as
> follows:
>
> [    4.388838] INFO: trying to register non-static key.
> [    4.395673] The code is fine but needs lockdep annotation, or maybe
> [    4.402118] you didn't initialize this object before use?
> [    4.407673] turning off the locking correctness validator.
> [    4.413334] CPU: 5 UID: 0 PID: 58 Comm: kworker/u32:1 Not tainted 6.12=
-rc1 #185
> [    4.413343] Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (D=
T)
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
> To fix this issue, ensure that the spinlock is only used after it
> has been properly initialized before using it in `ufshcd_setup_clocks`.
>
> Fixes: 209f4e43b806 ("scsi: ufs: core: Introduce a new clock_gating lock"=
)
> Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

> @@ -10412,6 +10410,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
>         hba->irq =3D irq;
>         hba->vps =3D &ufs_hba_vps;
>
> +       /*
> +        * Initialize clk_gating.lock early since it is being used in
> +        * ufshcd_setup_clocks()
> +        */
> +       if (ufshcd_is_clkgating_allowed(hba))

This checks if the UFSHCD_CAP_CLK_GATING flag is set, which is only
done in a subset of the host drivers:

drivers/ufs/host/ufs-exynos.c:  hba->caps |=3D UFSHCD_CAP_CLK_GATING |
UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
drivers/ufs/host/ufs-mediatek.c:        hba->caps |=3D UFSHCD_CAP_CLK_GATIN=
G;
drivers/ufs/host/ufs-qcom.c:    hba->caps |=3D UFSHCD_CAP_CLK_GATING |
UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
drivers/ufs/host/ufs-sprd.c:    hba->caps |=3D UFSHCD_CAP_CLK_GATING |

> +               spin_lock_init(&hba->clk_gating.lock);

Hence the spinlock is not uninitialized on all other host drivers.

> +
>         err =3D ufshcd_hba_init(hba);
>         if (err)
>                 goto out_error;

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
