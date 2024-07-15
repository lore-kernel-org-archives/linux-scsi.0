Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E4185E53;
	Mon, 15 Jul 2024 09:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721035765; cv=none; b=PKTrc+BLXBGA18SHrTs5RRbxF510Agz2ulHlc8ocjE5ZElqd2kj0jzk3qnFV87n02+MxL9tctxfJ2dfmnycQFdNJVicb+b4TcYH2/shqXbGhGIWTrzdcyRmZlGhO289I+Cg46xOLiVGTCGKgsCmtdfUzf77v+rk35y2S0pFXy2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721035765; c=relaxed/simple;
	bh=b7mFPIS7KuET9lAFKCCguvkomBVJYnuLNdS4MKxbOHs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jjkXexJlRQAxp0CIB7OVIDFcWaZ0fm0cLLoX83s+arygmtVCS71Q9rqiR5TLle5HMLir72J0iI0QLV4PDOLebPdMvjk5IQn9iumJIE9DQOpodFqbiJmHZZEFVRdPNJcAsjTTChRuz0jk3uRe/mtpXIEiO6sj8uo8lkSbJ1IKkfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbQZiVp5; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbQZiVp5"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-59589a9be92so5468278a12.2;
        Mon, 15 Jul 2024 02:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721035762; x=1721640562; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b7mFPIS7KuET9lAFKCCguvkomBVJYnuLNdS4MKxbOHs=;
        b=GbQZiVp5knUaTfeccePFGB0VOnUj346xTIjeLNuXVYShvWfBR9wKuUyZ+IZKaB6ury
         uxPLIEM3ydDmxP6q8Sx7iF2fPiVRpe6hXhwDgieBdoQtN8ovg/hrbDI/3cgKm5i8vfY/
         IoO0lu+Y//CB3SrQh0jwVCU81bGnj9viGIcsbCk3XbNMFd/xRk3c5Rb54nwL8bzcPZrV
         w8FtJqhCCxC7EQYPr+NaRAJwF5vL91Fs9X6O5XiyM3DxiSndTMbDag7VuxFpvAm5T8aA
         UVfNiGNJw1G3+kNqJKUHRy7jxqHnd4Afnj5BK0M3plhF9t8bjpB9PAi9LWBUV9wU1gwe
         j4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721035762; x=1721640562;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7mFPIS7KuET9lAFKCCguvkomBVJYnuLNdS4MKxbOHs=;
        b=q2P/AMbG7YUEiQuSzPnMJjq4medecvSH1WQ+24UAdwpBx1nbbLN0XxnzYSegUuydLU
         UWOIGdm8wtJgu9A7v7MDnBrSuwQk+1L1z/90Gc97CTIEfCLxjwgnuvdwl+wIgB8836mb
         3HNP6Di15X1c7dSHS6aLEDAdEla8cytuULBRQQ1sl4VEUy8zOI3rRbOgcmiBolc2Bnnt
         XRvmQ21n7IEstt0j4Xghk4ilGbvLs12h6h2rzigRO4nHiOdn8k3Yqhkcb17bLWNuAQLy
         iIDhghZqJ+WlGSCI75sFkxVCyzwA2vWtTAbZ+0JJJfM+3L7AuTonp/3s9iFjjME589Fw
         cmLQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3o87Ndipqjmyb0rzNalmbeGtxmC+1S7tLZn1ZJvZmYPyEyj+WoQQS4YKH5CUI2bPME+6345Lna5j2vBAL1QxMp1cPlCHi36ZeaJHhQ9zPBKvjf6qOqDNgJIs4hSlmzFzkGQ==
X-Gm-Message-State: AOJu0YxI2RPrEfeBNSWnDuWh8ez5+cD1axEW9IjKQTagGHmvOSPZeu9r
	faedhhWZ+59CWywVL/PrvcNG1rR3SLQoQ76QrP4NnrD2zRsXs7NP
X-Google-Smtp-Source: AGHT+IGv1K1+lIe/0yB05R4JzCCdf0eydJmVPPAPqknqyilGw1RhtZ7nOd93r+iW83j1MR/dSqKldQ==
X-Received: by 2002:a05:6402:270c:b0:57c:68fd:2bc9 with SMTP id 4fb4d7f45d1cf-594baa8bd2amr14998683a12.3.1721035761474;
        Mon, 15 Jul 2024 02:29:21 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b24f56d2fsm3134232a12.25.2024.07.15.02.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 02:29:21 -0700 (PDT)
Message-ID: <68370e680ab4d39ce5710086ee62711b22ea48ee.camel@gmail.com>
Subject: Re: [PATCH v2] ufs: core: fix deadlock when rtc update
From: Bean Huo <huobean@gmail.com>
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, beanhuo@micron.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com, 
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 powen.kao@mediatek.com,  qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com,  eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 chu.stanley@gmail.com,  stable@vger.kernel.org
Date: Mon, 15 Jul 2024 11:29:19 +0200
In-Reply-To: <20240715063831.29792-1-peter.wang@mediatek.com>
References: <20240715063831.29792-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-07-15 at 14:38 +0800, peter.wang@mediatek.com wrote:
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_rpm_get_sync(hba);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Skip update RTC if RPM stat=
e is not RPM_ACTIVE */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ufshcd_rpm_get_if_active(h=
ba) <=3D 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return;

I understood your intention of this 'retun', but my understanding is
you assume that __ufshcd_wl_resume() will schedule rtc update work,
however, before the time that __ufshcd_wl_resume() completes, the RPM
status is not RPM_ACTIVE until __ufshcd_wl_resume() completes and
__update_runtime_status(dev, RPM_ACTIVE) is called.

If rtc update work is performed before __update_runtime_status(dev,
RPM_ACTIVE), here you return, then no RTC work will be scheduled.

do you think it is possible?

