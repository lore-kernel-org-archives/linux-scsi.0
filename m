Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794702318;
	b=lRcTn/FIhhWQcsOB/eqHBEIe4EGVyDu9a+T2EgS08/N/Qq5YNmCWmzdbAcTUqr8JWUCL
	 zbajjbOIQKQGrCyCNk1NBLdPN4hYQM58UymRCwasdiaavWk0Apv8X510Kaodny1j9nMHc
	 Ur0hHAjvusjzroCgrwj7EviYUye328TZFW0/3DeDni2OHsUlRs/x0pXSgT/71f7J77//g
	 H0rr4TT1XGnt0r5+i1wwICo5Q+T0/x362qwi3PcoA3Y/aCuMKR7Ak/pSzvFgb8Tk4/au0
	 se8LegELfT7fp+dPP3m9k6EbMlmPtITRgZk6+yq5OHNNWdmQtpaxZF2uKgSOLSiu8HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794702318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Reply-To:Subject:
	 Content-Language:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=QBU+JY0LIvKeNHjcy5gTbrjwDNu63TsOHh29cK8nd4o=;
	b=WIQg4u6spFPgA83SOQ/ftNIzTyyYlybE94H9FSzEdJWJ33R3D98eoFXGJsUXp0IaKkGk
	 JBFHsGBssddPjdkpy6bh4oyyum29ctS0BrIRxymRuh6lYAXe9lx8+Rm6caBCdZym2G3BA
	 e0eiN0KtRgKNANNBfF/z3fkU14jMKk/W5QSG9DvyF2E+Fa/gxQRQkIXiPkcMiadP6MsSM
	 YrfahMlJStR5ZxMddZl9Iu1PsImn/XP/F/v6t28J+TDZnIvTUfzv2Qw8Dym666JR+d7Ew
	 xqho0GNKmsfv69YtxcYKGZA3Th9tjQQpIpt1k4vbeLPg7jtml95Vw6irenTbTRa3/NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Ols/R6zM";
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D41606A329
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 00:25:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33D41606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ols/R6zM
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36a315ed211so2175718eec.0
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 16:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794702317; x=1795307117; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QBU+JY0LIvKeNHjcy5gTbrjwDNu63TsOHh29cK8nd4o=;
        b=Ols/R6zMu1kix52YL4gO5G6t2l7MiCVboq6QHsHUlZh2C3x/yzt3IZrAH3frath6cD
         IHSwWZ8L9+AL+FuxJygZaWikHgFGc2CAl8pnkoeHXpjyjqFfP19Bo7uRxdluOcabnYNR
         zRii8/9UJcgRqZslD4goexaigmszzwT6TkqlMK75b8yS5cah+Td2FSI5WVGuH5+o8iE1
         0ilIhNSyE5ctI9aBg86g4QPNsrczsn6Z3ByBpMl0F9bGyNZbmWIHictoqeUQ0xWr/jWx
         6lij1GXYh6GTlCxmrMgDcbfX8DzpHAsFDNAxjNjpcpFY94Pe8U15mqheTpYJiwX6Phe4
         jtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794702317; x=1795307117;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QBU+JY0LIvKeNHjcy5gTbrjwDNu63TsOHh29cK8nd4o=;
        b=t4Dub75qPHiGOUJ/CnuGk5oReSE5prwDxK+kZSSGI/bxDFKwWxI+ptEdJXDC+Nb/iv
         HHpaDyM0KiuLXdRbnlcvP2qYyckjX1r6ago1FK/Mwfg/XVo9Dl3153xIq1rTBxiR4llZ
         Y5dn8ITHJ+cSvRZKzUU7o6D9WpHCvJCe3BdmEMn6S2m0U3/t+MaMVGUX9gC4EUvVGk9O
         uOJ/FZZP6fLNOPKC43ZPxJ5B0t/ugiOzN4ESo0qk7D8mTJgQQd2MNhPUGtyY1myJQLeu
         Q5X2fV6y4/2xjq/G4JAILlTyk790QQEIQ0799JHqcyuVPPT+uyrDtQ9tg1tdFKi8BDpx
         Rh1w==
X-Forwarded-Encrypted: i=1; AL+hErE3GCcJWVdY/0goXzFEPeyQsjTakO+vR5Q9XT5LgafG6WtwYbMX37I/hx+1KpRC6JQ3dSHmIvEg4L2f@vger.kernel.org
X-Gm-Message-State: APuU4Z/Wz/jUrRH86D+Xkv25cAqFp6TEPH1Lwm22vnY6zFsv6tY9+cVQ
	fA8eXMRXZ9bFgKOkpxnKBh2ePj1EZdtviAoSBtUWlnRUZ1Y9Gz0q/HA7
X-Gm-Gg: AYBFou1z2y4cP7U4hwVWDJsEl6UOBckKkv4yeDCRqFf8eOU//sSD75HhhiAn6E6RiFT
	h/G7kl32DV2Q3mpNRpi8AMy5tzllEO5uUFML/0JQb5CPUDOH6HSSxAIF190rTC9szaSgARgMhhy
	t5wISZSBVKiOIUq9AqyizjyS7NG6ipVFT/9sBrCAy6P5Ey/rhyAAIlpI2XebFALxEf+w30tRf7T
	54ZwKr/0BCd5k2NaJxXkaZsuCCOpobfzUrK7yvkioJoB9EI5ZmmdHM7mnMayGEwNr/ZgIuQbfex
	EZesq9uDjYEh7caKi33ol6/zJa6hzo7353YOu8CrHlzTGc7WUAeQIb5WnVoBVNxM426pGE0CDPX
	SRcLSna/XT3JDe7ylTrc61RtnW0cmRsNRyqb6BPJfe/meurTP6F2wRhgT/8RR7hJDJVJPNdX0Z9
	sKYTZpiVkO4u8O1CrmcTfdjhuz79moBlYMBtNC89qR//WAjbcuDd2c0KgrMwAS+/kD+heOkbXki
	jD6mc2ESDVA3jgYgUneq1mGhXywl7lzUYNGoFIesTMbfWlGuoLR1uxAI7FX1NITvt8Z6AKQ7dHu
	i4Hx1lPYaQX8MXu/JLI1/7HDtD5cC8hojjCzilEltm2IXf+IGWP0jSX9jovRq7l9gZA=
X-Received: by 2002:a05:7301:1509:b0:369:f3a3:fad6 with SMTP id 5a478bee46e88-379658c798fmr6036337eec.4.1794702317178;
        Sat, 14 Nov 2026 16:25:17 -0800 (PST)
Received: from [192.168.35.43] ([218.50.238.131])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955f01d68sm19708520eec.17.2026.11.14.16.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 16:25:16 -0800 (PST)
Message-ID: <a813b1ea-6971-4fde-b310-659a03963fba@gmail.com>
Date: Sun, 15 Nov 2026 09:25:12 +0900
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: chanwoo@kernel.org
Subject: Re: [PATCH v2 1/4] PM / devfreq: Fall back to previous_freq when
 get_cur_freq() fails
Content-Language: ko
To: Bean Huo <beanhuo@iokpp.de>, linux-pm@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Chanwoo Choi <cw00.choi@samsung.com>, "Martin K . Petersen"
 <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Stanley Jhu <stanleyjhu@google.com>,
 Bean Huo <beanhuo@micron.com>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
 <20260907192140.2701755-2-beanhuo@iokpp.de>
From: Choi Chanwoo <cwchoi00@gmail.com>
In-Reply-To: <20260907192140.2701755-2-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/8/2026 4:21 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> devfreq_set_target() calls the optional ->get_cur_freq() callback to get
> the frequency that is passed as freqs.old to the DEVFREQ_PRECHANGE and
> DEVFREQ_POSTCHANGE notifiers, but it does not check the return value. If
> the callback fails without setting @freq, cur_freq is never assigned, and
> an uninitialized stack value is passed to the notifiers.
> 
> hisi_uncore_get_cur_freq() can hit this. It returns -ENODEV without
> setting @freq when its PCC channel is missing. On the mailbox error path
> it sets @freq to 0 instead, so that the core does not read a random
> value.
> 
> The other two callers, cur_freq_show() and devfreq_monitor_resume(),
> already check the return value and use devfreq->previous_freq when the
> callback fails. Do the same in devfreq_set_target().
> 
> This does not seem to cause a visible problem today. The passive governor
> is the only DEVFREQ_TRANSITION_NOTIFIER user in the tree, and it only
> reads freqs.new. So this patch is not marked for stable.
> 
> Fixes: 0fe3a66410a3 ("PM / devfreq: Add new DEVFREQ_TRANSITION_NOTIFIER notifier")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
> ---
>  drivers/devfreq/devfreq.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index f08fc6966eae..f20d9a660779 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -348,9 +348,8 @@ static int devfreq_set_target(struct devfreq *devfreq, unsigned long new_freq,
>  	unsigned long cur_freq;
>  	int err = 0;
>  
> -	if (devfreq->profile->get_cur_freq)
> -		devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq);
> -	else
> +	if (!devfreq->profile->get_cur_freq ||
> +	    devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq))
>  		cur_freq = devfreq->previous_freq;
>  
>  	freqs.old = cur_freq;

I agree this patch.
But, I don't recommend to execute to function on if statement.
In order to improve the readability, could you please update it as following:

        unsigned long cur_freq = devfreq->previous_freq;
	unsigned long freq;
	...
	if (devfreq->profile->get_cur_freq) {
		err = devfreq->profile->get_cur_freq(devfreq->dev.parent, &freq);
		if (!err)
			cur_freq = freq;
	}

-- 
Best Regards,
Chanwoo Choi
Principal Engineer, Samsung Electronics
