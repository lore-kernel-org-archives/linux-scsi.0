Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018AF3016F1
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 08:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764663138; cv=none; b=Zo0DdVPuPmTC0fdmW0TEtsmm8W7Ynqs9gI8Yj5ACxXlYw4IyzoH4v3VKBBKQ922dZXEnhFR6qPaSqpWHlwx9QrWSzmKIBengvOdylUdlkL2n9J3rnHKsrZSflAWtpcKX2uWHQX1R/uWEcDhElZtisRfNPtL8QBIkaVyonXDH7lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764663138; c=relaxed/simple;
	bh=mWxBu4jp6WzKBs2dLxdEOU2DZ/Gs4+nB1u8h+TZfP2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XD6ZB+Mc8Ji/Vf7vfKzUZp5QxTdm5Qr8vlOUUUDQL4YjxwK6+tTqnzKd3qkAHpTWQqj5JFtq5cArHBBjETv4pT478qYRQhUL2bzRN7ABcPC6a0kiucuW4PCZh9vmIKWEmPY82bNTlXduiEgvefe5iUf+Ga1L9GF+RSueXQ5tFeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-640d0895d7cso6725191d50.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 00:12:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764663136; x=1765267936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B36oa751rRTMUwlNXN0qQhn7IgIXA2OPGJjr7TgO6ZY=;
        b=eNdkNLOVlONlEeD/s36KkjXvQL6qZdSmjlsoNF9MLabNZf7bKauftRIzqItIL3+tCW
         p5spIa6ZfqxB+0VSFnF14VsPifLbjZ+KCxyOeD63MoFZOXqSXh3IjHb+VMTp+RItoF9+
         wpw67XOVOnu7Dtsw5+TucAhgMrB301AXcJWIGP03E63+ZYS6NBvaSUFpa7sKyqb8PmN8
         qlzaE7YdRfldH5C3+hNqRLL/AS7T9TDeoZx62pp+r0Eg0qlRQMhNGTr5kLsB/j0lHobf
         pNLBnOPUUu023/EMLRQSmQyGQiwzJwg80GBgR2QvnaHyk2GWq9mK1GURq1kjOuTZSkVX
         IBWw==
X-Forwarded-Encrypted: i=1; AJvYcCWmY6Mr+N8el/zQjF1QEB7fShDegK3tXB+O8Udcbu/GWNjuXkYACAB64Pj4WrrkdmlJK2gQWY7d6mwW@vger.kernel.org
X-Gm-Message-State: AOJu0YyIETWF2r2Scr3WFplUveC6iIiALCtwzM+bjysMeDr16E6qwi6g
	MA4CEGmq4MV1k6EKlMBNQ/ieVezjnur+MlDlVodaKxxBJ9UdKCAJ/6uka1BESQ==
X-Gm-Gg: ASbGncvXbIq4tJ9Y8UfVc0Y6C9Bp1tjZCzE8k8BQ8m1xhTgnaenFtQ10ntWXzR5Ekpz
	e0GZCFgrb4zkYnmiUwKQyW+XftRITmatcEwtlE+PlMGEx3v475lWsiQGZSwffvs6Bi4vVprc0M0
	swlH0KFfECxDiDJ44vlgx1YJGbEgTAcLLBkKvCwp1F3q4WHCDpRsf3HZWifE4Wn9fGNsbDPaNWX
	sNAACBcR7geShOQLhEHX5d9kRUPdLYEMfpXwnBtV4wD394AOHfWcVrKXOjMlI24gCvyyRtFef9e
	eikzhw3XPBFpowRXOL2DcknwZdvbOeastyzvGzT6QFst9d97LNQgHM3gjXznyEy66k3na2kBHRk
	TCgQM5w8+bGdjE7spx8nF4xTiDloXYVDPsQtGl6wsVXv7mg10mT9BWrimHYIQRmFibmHpOUPELX
	XhPrEesyXJV0cjXzwhC2EgtfXORSMmM1KaRIfYoqOXIA==
X-Google-Smtp-Source: AGHT+IGGw4Gq47h7cpbXh8yn/2VXg+2+cwoaW6feVX41R2pXT4/rCDVHH0Evreuy99P0mY5u2zi3Cw==
X-Received: by 2002:a05:690e:14c3:b0:640:d1cc:2be7 with SMTP id 956f58d0204a3-6442f1af4d6mr789898d50.30.1764663135734;
        Tue, 02 Dec 2025 00:12:15 -0800 (PST)
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com. [74.125.224.47])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6433c4692a2sm5894966d50.17.2025.12.02.00.12.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 00:12:15 -0800 (PST)
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-640daf41b19so6669856d50.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 00:12:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU7i5shb8BquPUHPHt6Tiuvic8vJf3GBtSU6fg+zhtCVtTya5+SIdkKQncC3IP7AW2RPhmZSq8GRrbc@vger.kernel.org
X-Received: by 2002:a05:690e:124a:b0:640:db57:8d93 with SMTP id
 956f58d0204a3-6442f144d57mr1161167d50.15.1764663133868; Tue, 02 Dec 2025
 00:12:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031204029.2883185-1-bvanassche@acm.org> <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org> <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
In-Reply-To: <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
From: Roger Shimizu <rosh@debian.org>
Date: Tue, 2 Dec 2025 00:12:02 -0800
X-Gmail-Original-Message-ID: <CAEQ9gEk0TQ+=f16Lnmnx5Bh717h_CXcAcu_HjKxJWqPC2Xfihw@mail.gmail.com>
X-Gm-Features: AWmQ_bnwQuQkqsYOdSqARsukzneOmZka6jxgQMtU6mRzj1Mr9LZqxaGAmAkVAzk
Message-ID: <CAEQ9gEk0TQ+=f16Lnmnx5Bh717h_CXcAcu_HjKxJWqPC2Xfihw@mail.gmail.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved request
To: Bart Van Assche <bvanassche@acm.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 5:37=E2=80=AFPM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> On 11/28/25 6:51 PM, Manivannan Sadhasivam wrote:
> > On Fri, Nov 28, 2025 at 06:31:36PM -0800, Bart Van Assche wrote:
> >> On 11/27/25 8:59 AM, Manivannan Sadhasivam wrote:
> >>> [1] https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvana=
ssche@acm.org/
> >>
> >> This log fragment is only 55 lines long. Please provide the full kerne=
l
> >> log.
> >>
> >
> > I just copied the relevant log. But you can find the full log here:
> > https://gist.github.com/Mani-Sadhasivam/770022b53f11340fbaba06d8eaac184=
3
> >
> > Unfortunately, there is not much useful information in the log.
>
> (+Roger since he ran into a similar issue with a similar UFSHCI
> controller)
>
> Does the untested patch below help if it is applied on top of commit
> 1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
> request")? I'm wondering whether changing hba->reserved_slot from 31 to
> 0 triggers some controller behavior that has not been fully documented.
>
> Thanks,
>
> Bart.
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 20eae5d9487b..95f5b08e1cdc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2476,7 +2476,8 @@ static inline int ufshcd_hba_capabilities(struct
> ufs_hba *hba)
>          hba->nutrs =3D (hba->capabilities &
> MASK_TRANSFER_REQUESTS_SLOTS_SDB) + 1;
>          hba->nutmrs =3D
>          ((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >>
> 16) + 1;
> -       hba->reserved_slot =3D 0;
> +       WARN_ON_ONCE(hba->host->nr_reserved_cmds <=3D 0);
> +       hba->reserved_slot =3D hba->host->nr_reserved_cmds - 1;

I checked "next-20251128" tag, above patch cannot be applied, and
"hba->reserved_slot" does not exist,
due to merged patch (to next branch) from
https://patch.msgid.link/20251031204029.2883185-29-bvanassche@acm.org

This issue only occurs on next branch, so please kindly provide the
patch on top of next branch.
Thank you!
-Roger

>          hba->nortt =3D FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT,
> hba->capabilities) + 1;
>
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index d36df24242a3..46c98910dbfb 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -135,7 +135,7 @@ enum {
>   #define MINOR_VERSION_NUM_MASK         UFS_MASK(0xFFFF, 0)
>   #define MAJOR_VERSION_NUM_MASK         UFS_MASK(0xFFFF, 16)
>
> -#define UFSHCD_NUM_RESERVED    1
> +#define UFSHCD_NUM_RESERVED    2
>   /*
>    * Controller UFSHCI version
>    * - 2.x and newer use the following scheme:
>
>
