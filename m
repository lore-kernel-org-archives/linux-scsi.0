Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA6F125B9;
	Sat, 13 Jul 2024 20:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720901839; cv=none; b=Iih4LsVnt6XRpqi3wPuGS2BwoPofMeseMmr8EdjrEMg+1YdpxMcmnk9GRyummQf7LtacrdNjlVeRWq0l4B8ZTBSh6+O7vfzg7S5nh9KQjenTZK6gfrZHxXmgnrpz/GNBVb/TSOeQjsckcPm10e0ce4zE+0sZJpcAZq81hW8VmGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720901839; c=relaxed/simple;
	bh=lwxWyzAfdcoGBJ/UCy39/QZeuk7RCQ2GdHaRtr1hZgw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jRUZuuwuzMRZ54DtmJfmywqXIY0wexXQ6lKa5tevEYqbDlINjHE3SEgq04pBcGqGb0xZGecCRXe3GNqgdCHM1tHNZjylN5buAH7qViLFDT8kbF5w5UBPpl9+LnOnPbgzK5+N7Z5IzE5PA1LNvcN0Ex9SYvSmXB8Q8yz+EXQ0jSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/CWpfCE; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/CWpfCE"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42793fc0a6dso21182745e9.0;
        Sat, 13 Jul 2024 13:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720901836; x=1721506636; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lwxWyzAfdcoGBJ/UCy39/QZeuk7RCQ2GdHaRtr1hZgw=;
        b=A/CWpfCENIxPAr286O+Ke6ivQByy5I5qfqqkGiWKJXhrix8lkJ999qUslp4k21hsyl
         5NKGV2jIfzAkoQJ7TrFR8gUX+7Rv4OZlT68uxoIiAllFNkCZGzcgpYy4lEUmtkzrEHrX
         ieE2/H+pc1UHxCSUD/9wqpXT5667SHZGoxSmKk995sH74uVkglzYClB+JDtmR1GwuFxX
         Xwm0IQMm14pgKeMBkW5AFyE7jj+hzTMtlvhBCZhhNrcXzcEQSelYEA+dwW/dvdk7bKJ0
         96WonUWkknKZGvfJ/R+jFKo834MHRPXq0/zA38Auw5E83+G7EI/9xM1shhZlN3FOhNi3
         gM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720901836; x=1721506636;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwxWyzAfdcoGBJ/UCy39/QZeuk7RCQ2GdHaRtr1hZgw=;
        b=O0Oj6SqfB/Do35OBffpApCpGpqm0I2ieKY5ZE07tpG9vdnmYkTa7+L8EO+4hPtmPjz
         QNko8xwfK0p/+1tWZJqkb6vYj0+8CKHLgXpAjarL3kIII8AAZt3quZFUdOrTMUqRNicW
         tJOTu8ZxTATFjShrPWSyqb3qZsbP/vqpOuXTb5kq9dq8fidm/8EyTI1QE0eOJcuyDBwB
         6TsZqTz4u8lpTA+RbqW7UarRQIVz2beOT739QW2LnjrlOSrCrsnfrqmnT6mOWUfCvqIU
         dWhHCs1/g9bP0jkR0Wc+nUJkud0+xjgepUElND1orasNzPcsvPuLK1D/ZLKcosEOxTg7
         xIeg==
X-Forwarded-Encrypted: i=1; AJvYcCXcWCBVmE9Qj81qu3fj1bCKTcGTCQrTJ89BExpJah8WCMiI3N9IcOOZzvFcp6aIje2nDNnSr0IW7Vtljk+apW+1OeKQ5BLdzzzsZq+Vam7ombEC4Nj2Z01fk+sVuVIWjZf+Fw==
X-Gm-Message-State: AOJu0Yy9aHSQUY17iYeRc1e7paE+LoFlPJwbaD1c6N3h8WIVlqYpZ37X
	/MRq8Xzig3sZJkLY17ue17nsJcLR7Z0QtO9vnqtrlRKJC9MM1ePG
X-Google-Smtp-Source: AGHT+IFLBhP1h22J99UGV67Li6bdAzuvqEcIujjr6lLKXMQgpX5ElANP8+exxtSUOtHMXwi3gvGQaw==
X-Received: by 2002:adf:f990:0:b0:367:89fd:1e06 with SMTP id ffacd0b85a97d-367cea966f2mr9794804f8f.36.1720901836204;
        Sat, 13 Jul 2024 13:17:16 -0700 (PDT)
Received: from p200300c58740f79d67fdfc896b2e8c6c.dip0.t-ipconnect.de (p200300c58740f79d67fdfc896b2e8c6c.dip0.t-ipconnect.de. [2003:c5:8740:f79d:67fd:fc89:6b2e:8c6c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-368111d3e7dsm1783521f8f.87.2024.07.13.13.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jul 2024 13:17:15 -0700 (PDT)
Message-ID: <2f9038932ec77ce37b18667a3bace06e88a547f4.camel@gmail.com>
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
Date: Sat, 13 Jul 2024 22:17:14 +0200
In-Reply-To: <DM6PR04MB6575CF59300D4AB5E1BE1377FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240712094355.21572-1-peter.wang@mediatek.com>
	 <DM6PR04MB6575B81B788F260A8C640684FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
	 <edbedd4e992dd0adb93adbd45a74614c4c0f626d.camel@gmail.com>
	 <DM6PR04MB6575CF59300D4AB5E1BE1377FCA62@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-07-12 at 12:31 +0000, Avri Altman wrote:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba =3D cont=
ainer_of(to_delayed_work(work), struct
> > > > ufs_hba,
> > > > ufs_rtc_update_work);
> > > Will returning here If (!ufshcd_is_ufs_dev_active(hba)) works?
> > > And remove it in the 2nd if clause?
> >=20
> > Avri,
> >=20
> > we need to reschedule next time work in the below code.=C2=A0 if return=
,
> > cannot.
> >=20
> > whatelse I missed?
> a) If (!ufshcd_is_ufs_dev_active(hba)) - will not schedule ?
> b) schedule on next __ufshcd_wl_resume?

hba->pm_op_in_progress is true during __ufshcd_wl_resume(), will not
schedule update work.

