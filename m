Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA614D70A;
	Fri, 12 Jul 2024 10:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720781380; cv=none; b=Js7Nd90NQNQR3m4zLI8uRO3leTKsS7YiLXIQx2IhpzG8xmvZ9LDCTu5CIuaBfr0IBhcxjZDrlcPpt1Vrpn18UXGS1pfFaREdWPa8Hkn62ZfL1WdCBhpOM23TEyQBw/o3iOxJ0RCpTY+/V7aYlOAPfqpycf0/XAyBH9oZPPu6OY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720781380; c=relaxed/simple;
	bh=s5kG0Va5Ya0+y3YLlyiySLr3ls6IDhqCm0RNZwqEcck=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SHheMzUBh7Mu7DmOQNSHZtTVWz3msWGFgww5bTayi+6V52umr3mbKHPHQiAf7O4N39dkaLo70jmrtBlGZ0cG3TmHBGlXWAEV94F9yzKr8xHN60sSUkQHZbTC1UtNZsmjEcqHPNCCAc+tAhOaRHw934g2NbH0IQmnJJUftP9kGwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YUXF+ntP; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YUXF+ntP"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2eaae2a6dc1so28481441fa.0;
        Fri, 12 Jul 2024 03:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720781376; x=1721386176; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AHNZglGn9/b39z3tmaX5Svu14CP7RJqj1nZ/VmCNtgk=;
        b=YUXF+ntP2JnWJhBzXmFoRR0QNCizBiCkO1pTMieyxPL/Bp3H4ZNWLo4/Jvtb56r7YX
         qtd17yCFm8VyMaDTlYs9qaEdmKF4aUlA8M1GCCPhyJnVDrnAne4qoa6P4GowcTQEuUQ+
         TX5PKMYYtHavJrL5HYD+o8auCxKXPpRBR72P8AfcVcbPyh0wj5ywtOV7G1kBqYEHYGFF
         WIrOUK9sYQpqo9zvNB6SYLRBFgbErwP8BcDwcnEG2zMgfcAtMt8UlEwhEPO2GMT9D/rJ
         Ge08S3+6HyI1dJ4wxnNLoxTgIh/FQUM/2kgEcpaixm15eC9tVCn9kE/5b91b0I/EDJLi
         kAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720781376; x=1721386176;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AHNZglGn9/b39z3tmaX5Svu14CP7RJqj1nZ/VmCNtgk=;
        b=KiUx7nfLtmMVhp1HBQPpFirkIcWVDOE5xgIdapfqFFzRH/xZMVOs3ewZ4ULds2zyQ+
         BzL0y5WWeKYCKpM9OHESgms4vwPVcfQc2PVLu3ctuYVaZ8692E+hemLgO/AiaqxirvYS
         5fKu5Zl+x1orqPIAgfwjrbLfaH0Jwu+4sHYxwh4iry5VlB5JoMWuN5qLVvM59NcGfPEb
         Cso+sWLpunOkS6JAHtHbGA/V+CFYRGCMOlRfOAYt91O2l5ESz1dXKa8rLUTE+FIANekW
         BpG846U2e+BCrLA+qbvqLC3mvRFdHYMWAXlOA/XOpGdmx1xTI0ogV01pGz36AsljqlDJ
         3+Zw==
X-Forwarded-Encrypted: i=1; AJvYcCUdG34g/ElVuhgiRO+rRwjvSCA4ez8EnxJlq9FAKdD41VPe1GkC8TSXR1wJ2K9Sd7UXw9hr3iX58ndhQUH2yUfo5YMaMuTjffyaGMQBxMJzxbF5WdhN6ckf2f1E8IhF2iKFTA==
X-Gm-Message-State: AOJu0YzMltgv4rnMU4CHaySMn5XQdQMBh6KKmz/YjY5pd8qVkq5BsZ2s
	hibyHoqyEje9vV3Jnu0s77ibrekk17bBgn4b0Ez1tsIzwDuryyfC
X-Google-Smtp-Source: AGHT+IFaVuCcgov1TuLwUNSWWPnB5juRu3iKhpdZXsUUIEZvbsAKSYnn8VS94ZoTXu3lIU91P1E5Iw==
X-Received: by 2002:a2e:9e99:0:b0:2ec:6756:e3e7 with SMTP id 38308e7fff4ca-2eeb316b015mr90865261fa.40.1720781376172;
        Fri, 12 Jul 2024 03:49:36 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a6bccbdsm334098666b.40.2024.07.12.03.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 03:49:35 -0700 (PDT)
Message-ID: <edbedd4e992dd0adb93adbd45a74614c4c0f626d.camel@gmail.com>
Subject: Re: [PATCH v1] ufs: core: fix deadlock when rtc update
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <Avri.Altman@wdc.com>, "peter.wang@mediatek.com"
	 <peter.wang@mediatek.com>, "linux-scsi@vger.kernel.org"
	 <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com"
	 <martin.petersen@oracle.com>, "alim.akhtar@samsung.com"
	 <alim.akhtar@samsung.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Cc: "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>, 
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
 "alice.chao@mediatek.com" <alice.chao@mediatek.com>, 
 "cc.chou@mediatek.com" <cc.chou@mediatek.com>, "chaotian.jing@mediatek.com"
 <chaotian.jing@mediatek.com>, "jiajie.hao@mediatek.com"
 <jiajie.hao@mediatek.com>, "powen.kao@mediatek.com"
 <powen.kao@mediatek.com>,  "qilin.tan@mediatek.com"
 <qilin.tan@mediatek.com>, "lin.gui@mediatek.com" <lin.gui@mediatek.com>, 
 "tun-yu.yu@mediatek.com" <tun-yu.yu@mediatek.com>,
 "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>, 
 "naomi.chu@mediatek.com" <naomi.chu@mediatek.com>, "chu.stanley@gmail.com"
 <chu.stanley@gmail.com>,  "beanhuo@micron.com" <beanhuo@micron.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Fri, 12 Jul 2024 12:49:33 +0200
In-Reply-To: <DM6PR04MB6575B81B788F260A8C640684FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240712094355.21572-1-peter.wang@mediatek.com>
	 <DM6PR04MB6575B81B788F260A8C640684FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-07-12 at 10:33 +0000, Avri Altman wrote:
> > @@ -8188,8 +8188,15 @@ static void ufshcd_rtc_work(struct
> > work_struct
> > *work)
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba =3D container_of(t=
o_delayed_work(work), struct ufs_hba,
> > ufs_rtc_update_work);
> Will returning here If (!ufshcd_is_ufs_dev_active(hba)) works?
> And remove it in the 2nd if clause?

Avri,=20

we need to reschedule next time work in the below code.  if return,
cannot.

whatelse I missed?

kind regards,=20
Bean
