Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEE217BB6;
	Fri, 12 Jul 2024 09:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777876; cv=none; b=UDo2IblYqhAkFaPPvhBME2J9bKpRXO8GsJL9SJXQgEX7b9F3Qn1ibZGxo7NzEbx0F1QHF7gIKSV53cAdUmOetCUaVuBocp6NAtdC5EZUjxO+y/gvvl5X3l2TSY88/NbKyCDofXM2WrZP++66Yhw08sov5NADG3qhJhQRYI60iWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777876; c=relaxed/simple;
	bh=mcbo1O40NYoYZdrWPya8nyvr022z8GlP9Ixplradfzw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eSU3+IFWhBbnPWXrqfHx0kQ5U77xJWawk4gF5ID8H1ATq/Qqo+XE8aEKWImwWWnYl1MoNB6oN7Ni6AUxPCs0dVm9pW61IcO0y16MrD3h+7jLIKXnGQ0juSDQW8aIcL9ShWagW9j2HCTYnSvSOFYX7LUa/12VG4+n7qU/4jjs7Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M1GUTuj5; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M1GUTuj5"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so5154033a12.0;
        Fri, 12 Jul 2024 02:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720777873; x=1721382673; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mcbo1O40NYoYZdrWPya8nyvr022z8GlP9Ixplradfzw=;
        b=M1GUTuj5exHPyH7gkhAT8yM1inJVeIBPZamA0zowy9IoYwALwIOeZA0yGDb0Nfg7Cs
         SQ/c2vE06n44r6TIfet6GiriM7jILDOGpTs5NdChlGrF2dbC7TwVQPh/xPKPC93yeRDj
         hXaT1xOvVGVtWR3rY6AuHs4Ystb3X8RSVH8Cnf42NUfeps7c9nc+NWkXUwv8b2H3u1GM
         eu4/AQst3EZJKW6XXmCOxVAtAyma24PB47JIhbkeYXdUOGZqxofOIfqPuLUEovRNZ+WZ
         922kbznQDiciji/dZHvrN+XOW1K0NpX9VJs3RLFiUEpb2KJgA4zqccMcaJiGN5u2n/rt
         g29w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720777873; x=1721382673;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mcbo1O40NYoYZdrWPya8nyvr022z8GlP9Ixplradfzw=;
        b=Ybedk/9lhQSMUfojkwKyaPkiGLDU5lJo8ek8nI9fn+Lfakf0Y3Yp1Odlj8I9yXxQRl
         zW74wtlK1dtvP7yY4TDue5+gVm6u6xwt5PLzKdM9G3+dn07Q/rHhMQWOdg9hlp8o4PyU
         gkClQ1RGdURGoXT4CVVzRytkDQ7iQZm00VvhQvqKtUvrNWjA5Q9GWSyAT8M7VedJ9jjq
         3t+9AT2XDKQqA3qLTrFwBW/P3aF1l5o2EWGKBSFInCnLxpkLTsd6Mqta3Mw0jLgUdvAF
         7ojnIviX8A9qGjUOIGt5ML0NAqoqS1xS8sc4QNaCv3XZ8tqsF/FJxYbqxjGnfw89k5RR
         ZwGw==
X-Forwarded-Encrypted: i=1; AJvYcCXApmyIbpoqGnLcWwGEhkELvh7gZbmxEsSFPdH3YBu0TeHZ3bexoF0z1KsHCBjsPSSTRx2idUP+CB/NABfKFEgIijRTm6mWsDNBDKeWjUOSDGb7GoDDJiGuvZaApw5Z66bYNw==
X-Gm-Message-State: AOJu0YwqpLBp+wXlBrURUryPT/NDvHimV7Szs5k8TVR2giGDBfXPutJO
	mUB4Oex1UMFiYpCM1UMCPAonqP4N4PD8Ubf1H5OAqo+vRIWF1Si5
X-Google-Smtp-Source: AGHT+IFanRBXAqJNBbDeVq14+irw0WN8X0FhrLWxA/HrfYnU4ajfi98RHQ9BMdUCyn7WZEvJyjUfCA==
X-Received: by 2002:a17:906:528f:b0:a77:ce4c:8c9c with SMTP id a640c23a62f3a-a799cc4ed03mr152434066b.8.1720777873034;
        Fri, 12 Jul 2024 02:51:13 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a6e157bsm330649866b.80.2024.07.12.02.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 02:51:12 -0700 (PDT)
Message-ID: <cf08dd694b3478e53bf07a4d916424de10f7e1ab.camel@gmail.com>
Subject: Re: [PATCH v1] ufs: core: fix deadlock when rtc update
From: Bean Huo <huobean@gmail.com>
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com, 
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 powen.kao@mediatek.com,  qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com,  eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 chu.stanley@gmail.com,  beanhuo@micron.com, stable@vger.kernel.org
Date: Fri, 12 Jul 2024 11:51:10 +0200
In-Reply-To: <20240712094355.21572-1-peter.wang@mediatek.com>
References: <20240712094355.21572-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-07-12 at 17:43 +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Three have deadlock when runtime suspend wait flush rtc work,
> and rtc work call ufshcd_rpm_put_sync to wait runtime resume.
Reviewed-by: Bean Huo <beanhuo@micron.com>
