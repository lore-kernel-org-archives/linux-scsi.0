Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A3926CE17
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 19:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791052; cv=none; b=SHXxEXZzXxyC4Hoftg0jAwLycDzMh5tPLAkT1lOgR9BbIy+q/XzVL0kL+VdXR0l4nLkkeTId7Ra7XLfEXmGocO6D9nW9lxXAy041YTCKW//THJXBLN1IA5vtFMxbMiVMCyRNVPv5DvzdTl2QmzfnRdqirFbB26sPeHKKDNfDF50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791052; c=relaxed/simple;
	bh=LsBJv7kMUHZ0L33uQ+VX0oDqyAAUdCMmajWRCzCJmz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MghSiaAJ6N2IwJnHMuTc0Qob+pCLyt29VSP8yYQWcJC/IYCrxoJW6yrNRfI0KTjlkTIJCjU2G+a7wGs1iRkRwtjLE/m60P0oMsOs5GR2queWGDloqk6hh1E4koowarJJlc2WndzfGYLRuoKrl+hTCh3ZwtPXHwj8hsYhy/BOL2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-641e942242cso78811d50.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 11:44:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764791049; x=1765395849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U8/JAOhAu1Et7gP/RZLZQPFh/TOfCcoWjqb0rhcAYUo=;
        b=rMB6iJRHfiTnmDvx4Xku3qJ5R5toj7RcR091WpiU7JFiSaY06o/Kbn/SfyUxCJsWlb
         scDPe91VfesJcq08kdmGLalMqXzmXnptHIt5dBhZoZ176925GZmDjocRtCYtOFybLRJ/
         t98qFXkX2ZlP29ftTCzRy0n4IdzWg36rU6WcLLp2rzuD2INwl2kEbC65BbQD4q6FWzFY
         IlPqNS2gM/L6liyD9vtUPhNigIOhYIFlqLG9JYl4+0gpiEywzUZ171fbZzWwz0+gyKiP
         ibBrpJtShm2QeshTetzn0Zl1QsDXY3D6tlnwChtI1Gh9PZ4MsjIwBI67zbHFScBxFS/p
         4FRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0BI/0Uuds+tPZ+K+JTcrN+8PoQH8wvx1ngFKuACZA3pbwgaYia94ej81BYy/EP2TpmtVtnBfIbqSQ@vger.kernel.org
X-Gm-Message-State: AOJu0YydP4ldUWZhsRGPZVs6QbHenxr2V9vMSJk2GTSAkJVmGv+gxyHD
	C9v8KdIaKkcffOziTHlhxgRpvYGO4MnjUqnot40mS3279LIMYyFj82ONqYcVuw==
X-Gm-Gg: ASbGncvs3+CPfGE4Ke/3nChfFzmpjyvYoXlVRbicQZuvad2UOXC+6g9AI0XjvqDHAGY
	WYzxl4i5m1I4L3SgGT8PCBuJMh5StYGZ/QjllweVo+iDkyu2ceeuDpZW1m+d3BY6IrZ9DVP9afJ
	HExy2t4cp0ZT5vojJr2RPmpw1smbYbAZeA5+hDAR1N8Ghh0EWFakhrlRT+R7Qkupg0SGa+w7xNv
	LPVXxKmPrAILBmUkvXvig7nRREBmyo8JQXOf7WF0Dsf8cCxmcCy/varAVcUu+XRPY2XKEaPHwBf
	QFUSP0cDm92GrEfPAhB1jOcCP6I08SlFxgk8Z0xYfZn8jTnp0OAUm5FcoK7EXe+66rtYkIXX19P
	kEkLQ+IUhim3jH+tNMgEGW3m2ndKOQjbRixfA9Icft6WI1z+wHNdvccppgclOFKSeGwazcnVbyU
	7wDLzT/egq7Ekg4IVrkh5EvRyEdnvLzXSPqexG+1GlWw==
X-Google-Smtp-Source: AGHT+IFxS4XgGBlM1mWJxz5eOBwrfnXPd+3FKhHYOn1XU6OjItDOaGJRUMbUwqcacUYiojj3YMZ1LA==
X-Received: by 2002:a05:690e:1915:b0:640:c7e6:76f9 with SMTP id 956f58d0204a3-64436fdea86mr2635966d50.34.1764791049080;
        Wed, 03 Dec 2025 11:44:09 -0800 (PST)
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com. [74.125.224.49])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad1044f9esm77256877b3.56.2025.12.03.11.44.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 11:44:08 -0800 (PST)
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63f97c4eccaso52287d50.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 11:44:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVSKCHoWbQgU4Xp8L5w5dGrsJUiL+Y6TaaDBPCJr0Z8T0iPQI6yKNNv13Gxa+4cq6L16BEfWMVyoTz7@vger.kernel.org
X-Received: by 2002:a05:690e:14c6:b0:641:f5bc:6991 with SMTP id
 956f58d0204a3-64437097072mr2411783d50.77.1764791046666; Wed, 03 Dec 2025
 11:44:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031204029.2883185-1-bvanassche@acm.org> <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org> <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org> <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org> <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org> <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
 <84b00b56-e775-43e6-a829-85e5da43508e@acm.org> <462fb80d-7614-41b5-aac6-2492845d7468@quicinc.com>
 <250c9b6d-dc2a-4ad6-b3b7-e29e9a2c4798@acm.org>
In-Reply-To: <250c9b6d-dc2a-4ad6-b3b7-e29e9a2c4798@acm.org>
From: Roger Shimizu <rosh@debian.org>
Date: Wed, 3 Dec 2025 11:43:55 -0800
X-Gmail-Original-Message-ID: <CAEQ9gEmnBj-ofj9VtZ1O04M9g4hHLA3yP=Y2QZjc8vUX+Sxy-w@mail.gmail.com>
X-Gm-Features: AWmQ_blmwmJUP2xG8okbBjqWxFdhoVMnlWknZ_Oy8chnM4s3Qzh75jOa1V-lzbU
Message-ID: <CAEQ9gEmnBj-ofj9VtZ1O04M9g4hHLA3yP=Y2QZjc8vUX+Sxy-w@mail.gmail.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved request
To: Bart Van Assche <bvanassche@acm.org>
Cc: Nitin Rawat <quic_nitirawa@quicinc.com>, Manivannan Sadhasivam <mani@kernel.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 10:27=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 12/3/25 6:47 AM, Nitin Rawat wrote:
> > I tested on other platforms - SM8650 and SM8750 , and the same error
> > occurs there as well. Seems like the issue impacts all targets.
> >
> > I suspect the problem is related to the new tag implementation in the
> > device management command.
> >
> > Below is the call stack observed each time the issue occurs:
> > [  274.480707] task:kworker/u33:6   state:D stack:0     pid:94
> > tgid:94    ppid:2      task_flags:0x4208060 flags:0x00000010
> > [  274.492127] Workqueue: devfreq_wq devfreq_monitor
> > [  274.496964] Call trace:
> > [  274.499481]  __switch_to+0xec/0x1c0 (T)
> > [  274.503431]  __schedule+0x368/0xce0
> > [  274.507025]  schedule+0x34/0x118
> > [  274.510354]  schedule_timeout+0xd4/0x110
> > [  274.514393]  io_schedule_timeout+0x48/0x68
> > [  274.518608]  wait_for_completion_io+0x78/0x140
> > [  274.523178]  blk_execute_rq+0xbc/0x13c
> > [  274.527038]  ufshcd_exec_dev_cmd+0x1e0/0x260
> > [  274.531431]  ufshcd_query_flag+0x158/0x1e0
> > [  274.535646]  ufshcd_query_flag_retry+0x4c/0xa8
> > [  274.540215]  ufshcd_wb_toggle+0x54/0xc0
> > [  274.544165]  ufshcd_devfreq_scale+0x2c0/0x448
> > [  274.548645]  ufshcd_devfreq_target+0xd4/0x24c
> > [  274.553125]  devfreq_set_target+0x90/0x184
> > [  274.557340]  devfreq_update_target+0xc0/0xdc
> > [  274.561732]  devfreq_monitor+0x34/0xa0
> > [  274.565591]  process_one_work+0x148/0x290
> > [  274.569717]  worker_thread+0x2c8/0x3e4
> > [  274.573576]  kthread+0x12c/0x204
> > [  274.576895]  ret_from_fork+0x10/0x20
> Thanks Nitin, this is very helpful. Is applying the patch below on top
> of Martin's for-next branch sufficient to fix this deadlock?
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 1b3fe1d8655e..fd0b6b620b53 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1455,15 +1455,14 @@ static int ufshcd_clock_scaling_prepare(struct
> ufs_hba *hba, u64 timeout_us)
>   static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err=
)
>   {
>         up_write(&hba->clk_scaling_lock);
> -
> +       mutex_unlock(&hba->wb_mutex);
> +       blk_mq_unquiesce_tagset(&hba->host->tag_set);
> +       mutex_unlock(&hba->host->scan_mutex);
> +
>         /* Enable Write Booster if current gear requires it else disable =
it */
>         if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
>                 ufshcd_wb_toggle(hba, hba->pwr_info.gear_rx >=3D
> hba->clk_scaling.wb_gear);
>
> -       mutex_unlock(&hba->wb_mutex);
> -
> -       blk_mq_unquiesce_tagset(&hba->host->tag_set);
> -       mutex_unlock(&hba->host->scan_mutex);
>         ufshcd_release(hba);
>   }

Yes, this patch fixed the boot issue on my RUBIK Pi 3 (QCS6490). Thank you!

Tested-by: Roger Shimizu <rosh@debian.org>

-Roger

> Thanks,
>
> Bart.
