Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794220097;
	b=KNYUwBOUgO+hh69ouVJCW5dVF+zunMwEBEkQUkDJ6t7cD0LDtQcm3DZ11wlXYOtMLikc
	 pkKb38qaV59i585ZrmCFRpg8upz4LrHdNFXMPY9th9KaM1Sx31vd0iksvUJr5bOwNRVWO
	 YeI8LWCAoSr755YxoT3l4k1+zxPaQz3M/M+40/fhRrjZRFqcBPCwu5Nk7WBsQgkXv3oYl
	 UHtq190eQrLDKdyxLqy1mtAof0mxwzjkB1sGgyaDEgi/0qDT1K8dPNOrzPsKet0eelnyo
	 mQmt7fdsq4iQzGQkQKAng01OIQw8TxO0vNncgQ+dua9p11RxiARY+YwsEOvZEzGpHHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794220097;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YzoKSfiC/AhSKapcw2wsRzx1iaRFXs2ZfT9x8CFQDSQ=;
	b=IkT86O42OnsKNSOKG8XLc/90gwYqiXThzVCy4A2vren+nfsaZgqjzWi+enOAK/VSvPUJ
	 HNLi65M6o81YnQsmY3v6ST6t/Hc+MRC7IYsUMIHBG2U2h7yncDXFRmntXx3fMrS94t/Ab
	 jACL2D77rRPIkrrt8S3Sg2E2nzXQenQDs27eDRryc80KdwNsiSI6mmXOPnUGOQtvYx/fN
	 3hG8qofObXSNp3PAGklHKSHDowaER434E4+geLLhjn5rUECtpoLvz71Looja3VT40xx+X
	 zlwdp83pbBN4jj0j7BdpT65wAHdoaJNZMADcQHlQIjvQRwMZFkGNix4FR0eMYUv9pJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jeteANmY;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3DA606A322
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 10:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF3DA606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jeteANmY
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48df4f7ccf4so30218f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 02:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794220095; x=1794824895; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YzoKSfiC/AhSKapcw2wsRzx1iaRFXs2ZfT9x8CFQDSQ=;
        b=jeteANmY0VL6R4YvcRD4sLqKJyLnLKr4Jwz9KhI3YlBStLIh5/S/1jzYd2RICfNHyl
         5vQSK+3DCP7j1LxfoxPIb5bWHeAWj0ga1gt1BrdgGY54XdtevRmi5rh3x6yaCct12yut
         AH+F19hFBr1aVUpWJUxNMaL1NLEqNIQG9ENOWPZ9ri9SVfKqKjoTaOva1wEXWscEdcMl
         MIpP2XCX1vEv4bIXw4XV/NJ21M5tGo7I165qXR14unff+cN3G0BwrK+S1xec0B7bt33t
         ASzjyAFrAKFyCshGVMtJcPnzmPJchb7N7I1pb96iLYihQF3CwhXHjJxmRCfV6d+mwqQH
         gokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794220095; x=1794824895;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YzoKSfiC/AhSKapcw2wsRzx1iaRFXs2ZfT9x8CFQDSQ=;
        b=dRSgZVwepAg2Kr1eePKxb0jpPTisQRuF9O2EVzhSqItavrS5WbktnmcDGIVh9x4jxT
         t03ImSE75RRUq5LEjfPNcWpxfR4s4oxomunn15Ok61oShOw8nqVTPdOGLleEOh7LCdLI
         aEE9HcLVdrX2deeg6hjFYxoTZ2RkrY3eClOJGhkzHFx3X8tBkuz25JiTooa2jiz4MoGa
         oM0v18hycFP4VZK+Fs48ja+n1HtWG730TuPTWilr+Mq3lqnMVWLF8w+UFZJxHRUVuMkZ
         PJmDnzd0+orLJhRr+0Eg5wG7PCIr7wvG9n3I1QP60zLKQcL2wa5K/YssIa7eW3LJf11O
         RAqw==
X-Forwarded-Encrypted: i=1; AL+hErHOJSRx3jpkyPFNoxX4STn8SqnL3eAZZTmqxh6wHsj2AblHigkrZHC9a8ym/exF40WIKtww7XtDOK0t@vger.kernel.org
X-Gm-Message-State: APuU4Z/QprN4dzkg2tI6gxjxwuNuRvHrb8jWO0OvUTV4E1tvQUzBQHYD
	QJL2zFvwWsXiLzf3NAG+/9blEiSImubbOfn70mhVhqk/RrES93NZZPk=
X-Gm-Gg: AYBFou1LFZSeUfaeUIskTSNoTuXrxL7Kh8WAp1WuSYWhR3n5FfdzA66rRpGbDiZ6Aej
	8YAukf1E9yUSG1HJQZ2Z5/XexAhlHfJUNEBm5EjJ5uTBw4OLzbWHwEvE24u3QDLnOwDV8FvCjnc
	gf3Ex886q+AJTJgaYaVy9k+YZN+2PdZ5doyqOfesqJ0Wx3E64K3vEH05aGAGuIpAUqze9bFKqmt
	7HkyhKQR8borKOtFaAbBgmuz/BlQ7sKVD3YEjPH7XfI6jgGa7lvIpj/b7aa0PpeIaaM3zBy39Mj
	HFTcJpPz9qb2tPqHtApvWNM06Jb8zfG3Bg0ydy7gd4CbYvxIOuAfSQVlsRoZ5wW6/Qq+OcUbUf5
	0qlm7U/X2bGAAvufgi4LB02aHo3D6P4Y3dPxwFQz7FMwrpKcbyNvNte3YYIUgjgAijqqIIh98Tz
	denrfdoNJDC4QgIaPirDkQnhd0HxELlNRxki+amwKQLfHicCm/6W+ucS1bXkV6j7P93untMnzMz
	stGWqXQawHA1L8jWzo0ivWTp7pjt669NalOi6zlD8HGOxLznt9I9IWEgsPbdmvM9wrzy3SdJ49W
	5XeywwjPkwtIFnrruhBVHYss2/joG47UbRrM/1KRg7tuLNf8HPP9bMD2VdPwo04q
X-Received: by 2002:a05:6000:230e:b0:493:9233:ce65 with SMTP id ffacd0b85a97d-4957c6e3a22mr7285786f8f.0.1794220095238;
        Mon, 09 Nov 2026 02:28:15 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597d09e20sm9165541f8f.54.2026.11.09.02.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 02:28:14 -0800 (PST)
Message-ID: <d3e9eaa7-fff4-405d-a7cc-d5daab77ae16@gmail.com>
Date: Mon, 9 Nov 2026 11:28:13 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH] nvme-cli: nvmf-autoconnect: Consolidate vendor-specific
 NVMe-oF udev rules into a single file
To: Martin Wilck <mwilck@suse.com>
Cc: John Garry <john.garry@linux.dev>, Nilay Shroff <nilay@linux.ibm.com>,
 Guixin Liu <kanie@linux.alibaba.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 Martin George <marting@netapp.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 Zou Ming <zouming.zouming@huawei.com>, Li Xiaokeng <lixiaokeng@huawei.com>,
 Randy Jennings <randyj@purestorage.com>, Jyoti Rani <jrani@purestorage.com>,
 Brian Bunker <brian@purestorage.com>, Uday Shankar
 <ushankar@purestorage.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Marco Patalano <mpatalan@redhat.com>,
 "Ewan D. Milne" <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Daniel Wagner <wagi@monom.org>,
 Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 BLOCK-ML <linux-block@vger.kernel.org>,
 NVME-ML <linux-nvme@lists.infradead.org>,
 SCSI-ML <linux-scsi@vger.kernel.org>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20261109000834.513230-1-xose.vazquez@gmail.com>
 <f2b862d6106122031d3ad93ea3bd1a7964508de7.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <f2b862d6106122031d3ad93ea3bd1a7964508de7.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 11:09 AM, Martin Wilck wrote:

> On Mon, 2026-11-09 at 01:08 +0100, Xose Vazquez Perez wrote:
>> Cc: John Garry <john.garry@linux.dev>
>> Cc: Nilay Shroff <nilay@linux.ibm.com>
>> Cc: Guixin Liu <kanie@linux.alibaba.com>
>> Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
>> Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
>> Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
>> Cc: Martin George <marting@netapp.com>
>> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
>> Cc: Zou Ming <zouming.zouming@huawei.com>
>> Cc: Li Xiaokeng <lixiaokeng@huawei.com>
>> Cc: Randy Jennings <randyj@purestorage.com>
>> Cc: Jyoti Rani <jrani@purestorage.com>
>> Cc: Brian Bunker <brian@purestorage.com>
>> Cc: Uday Shankar <ushankar@purestorage.com>
>> Cc: Chaitanya Kulkarni <kch@nvidia.com>
>> Cc: Sagi Grimberg <sagi@grimberg.me>
>> Cc: Keith Busch <kbusch@kernel.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Marco Patalano <mpatalan@redhat.com>
>> Cc: Ewan D. Milne <emilne@redhat.com>
>> Cc: John Meneghini <jmeneghi@redhat.com>
>> Cc: Daniel Wagner <dwagner@suse.de>
>> Cc: Daniel Wagner <wagi@monom.org>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: BLOCK-ML <linux-block@vger.kernel.org>
>> Cc: NVME-ML <linux-nvme@lists.infradead.org>
>> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
>> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

> Generally a good idea, but I think nvme-cli has a GitHub based
> development workflow these days.

While GitHub is an option, web-based interfaces tend to limit patch
visibility and broad review reach across subsystems. Mailing lists
remain far more versatile for cross-project visibility and discussion.

> I'm not a fan of repeated lengthy match expressions in udev rules.
> Can we improve the readability by using GOTOs and LABELS?

Using GOTOs and LABELS cleans up the duplicated model match expressions nicely.
However, the scope of this patch is intentionally kept to a pure consolidation.
