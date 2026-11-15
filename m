Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794702453;
	b=qK3a0mSI9QftThCNgsNJU57/6EgaYgmY+QO3cBu2uM6rIe+b5NXjGa2EScO5h1J+QArD
	 VhIR2SQlIDrkGYhMPf10oUeHFfxACfUBdkEe5m5BntD9DwF7RqRn6LRwRcvQzxgOSLtgQ
	 sNRh7E/uPSPTmyb4p1wLqPrzg1PLr7QMj2PSOX14KTKZQ1WlQ3BSCe2/ewl7BJqHjABNT
	 umbDNN1qyCYvFqhuLJQ9+4ySwgGOSqVdrB2oEbLCZTDF2LVR0BZew382hXMixOv1eYtYO
	 R/SzVvgSr3ue4jwMpelRLjyd5Vefr/9h4qPH//LDuvQ86rXnj1CO9JDKLzzbkAGsVaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794702453;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Reply-To:Subject:
	 Content-Language:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=u9+e/eGHjR73QRvGijIdIOH0R/G/DJBbLevQ8HFggAw=;
	b=1N1dtg7ppPWZiHyN7s3Hvy8MYeOWSFun+bJ8uVwx81MDg9ER1uNNW4R850IzIZrwHSH+
	 7WILuAcAKE8rJOSU/oPq4UIy2Dseda/yHAHBFr9SW9F9TKVWtDXh8E+3igSqtIMDkE4tY
	 CeBG2LSwYczzmzHxdD7G7zintQDmBxOis8b3jIDdMGuwDr9DqljrQdhkQrBWDfG+7NdHG
	 GSYUwTvwg3fY/GpxORXxrGrCQbkI9lqT0afolxeVgMRhNVlBT+SfMw8UN7/14Pa2ypZw2
	 aobRIIVKiyivAbyf0euTzDS+bMDHjK2XB5dZpudurukEvwuSJq6aL7j43zjSbLJvLxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mnISHfT1;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97F5606A329
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 00:27:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E97F5606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mnISHfT1
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-15dd124bbe7so2098529c88.1
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 16:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794702452; x=1795307252; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u9+e/eGHjR73QRvGijIdIOH0R/G/DJBbLevQ8HFggAw=;
        b=mnISHfT1ZwT0S7pwLXfYK1XT8B5W1NMnt3+b8uJOvqsR3PYKLTCSH9RRGvexEqN1lW
         nbT/vGpIItUzSDwYG9pODU/ijNVun87sN2/1zYWxWPAQR0dOFnbm9C00imDKHW4ZtKHG
         bv/JRjQ71fdigYHckXAvtGV/BMvLaKO3g2V8uwu1On8416qhMLS6szR2NYAnUHmT39ec
         +d/MOVCbzYoH9+yslnPNfgKNYHlady3TvmJn4VQ0D4hRRs4lUlBEunWSWJyzKMJKAt/t
         k6lufnxWNXtDyiC/LTVudEaspBO7HW+slPZ5ROwqH5+wIzx2sZF4Wtgr0A64iLWj2avV
         XVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794702452; x=1795307252;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u9+e/eGHjR73QRvGijIdIOH0R/G/DJBbLevQ8HFggAw=;
        b=uyrUIegoFtvul2zbkWPgVKuKT1WFalRg/pYklxfnKSqnoio7TKH8kK0YovlQhzGSbf
         rsQ9annO2Lig8da7hEhCTW3NOCYEclNfIicojEkuxNDYcSE8QO9wImyRSVVCftdVTilw
         tFDkzbQDwARwFdEbmvCh1WHebMVYK6vxg6ewEg/kmPQuyvGCKsnr04iXd6aYVEUf1oRQ
         y0ugrTu6C6TYaSqLKV9csedjupaWAebOrVAf6JlyDlGk2nBuc61qlLBrw/2oF7aRwbZk
         qz5i6CS4wSzcxVsVkf4/qYeMoo+ghRqb1+qB5b+eKQdlf4tEX0jVEW169XmurTrLRomD
         KQMQ==
X-Forwarded-Encrypted: i=1; AL+hErEX8Nib+41RoHbEKaXorK4N2+jJ/CWSYNWKi6qS1PEx3IV2uZhTGHi6x+ejGY4bf1pm8DjjL8oTaG+J@vger.kernel.org
X-Gm-Message-State: APuU4Z9OsNAu3e7wK5y6YJy4IWphDXKrCrgXhLJiqI+FunR8BIX/3jkA
	gihMb6N33r+wTDKIAIdUPMhiq/BCcJE8fjP/AdU9T1UoMKnDX1mHXpgAhjJNL0VadDk=
X-Gm-Gg: AYBFou1/XxDPlMaOGYVFJQYWtRovSbEbkybv0zrNzus4pXUMaMoqyZDlYQvbbjY3hx0
	XrmJvfXKe+0CzzoPxHV5wVRoQQgAVZI080P0nGuk9qSzJTL3edauH8E9bmLWrXu9oP4BRtXFDHR
	o+TM+8xt86EOgxKe0lgxUTNcCMjs6RHnAEnzW3Lu/GG/u4ohUZ2wnv6qA7yYOzZotWx54bK41ML
	NGqYLcxZj/yIU4lCJ0j2teCGvnGZmGU1bwBe9xy2nwVa+94O8u42MKcfoxZLRBk90+H0B6w9oVD
	gTmKaPUz6fOkqAv0OREQPgwhui3qV4L87s67tBq42ZjR7yXZLj8oblZ8BGQ9dYxGU2Hinjv0tog
	J6hoRCS+OCI+WcVWaFdowgJFj6so0s7AIdb2HeIbqkHJjxUgtQwnjkuesoUECgySs/YcM9mThlY
	ESMevD6j9ych/GcOE/uqei50SL9u9UZhHhmb3OiG5CvuUqZFdP0ifKk1PFw9JMYqINt3f9ZjgK5
	WA91c2hMxoseMQFDpfSMr0MXDPDmox99wZAnfqn/F25QNdv6dhzppEf3M+5h9YqiUVMbdYjoPRw
	/bIMYKIoD5DkM4zUAzM9klZeyzQm3QK93xKLxlvHe3hUeEFiog/LizCq8HXL8PUv4Ns=
X-Received: by 2002:a05:7022:2529:b0:1b4:fa58:9d8 with SMTP id a92af1059eb24-1b5031759b2mr9369895c88.20.1794702451866;
        Sat, 14 Nov 2026 16:27:31 -0800 (PST)
Received: from [192.168.35.43] ([218.50.238.131])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50309b2b5sm16613754c88.1.2026.11.14.16.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 16:27:31 -0800 (PST)
Message-ID: <2771f4fa-5c55-40f2-8105-0d72a715ee3c@gmail.com>
Date: Sun, 15 Nov 2026 09:27:27 +0900
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
Subject: Re: [PATCH v2 2/4] PM / devfreq: Add more details to the
 get_cur_freq() comment
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
 <20260907192140.2701755-3-beanhuo@iokpp.de>
From: Choi Chanwoo <cwchoi00@gmail.com>
In-Reply-To: <20260907192140.2701755-3-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/8/2026 4:21 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> The comment for ->get_cur_freq() only says that the device should
> provide the frequency at which it is operating. It does not tell the
> driver author which unit to use, what the return value means, or that
> the frequency should be one of @freq_table. These have to be found by
> reading the devfreq core.
> 
> Add these details to the comment.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
> ---
>  include/linux/devfreq.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index dc1075dc3446..809ef29b9af5 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -90,8 +90,11 @@ struct devfreq_dev_status {
>   *			use this directly. Instead, governors are recommended
>   *			to use devfreq_update_stats() along with
>   *			devfreq.last_status.
> - * @get_cur_freq:	The device should provide the current frequency
> - *			at which it is operating.
> + * @get_cur_freq:	The device should provide the frequency, in Hz, at
> + *			which it is currently operating, and return 0, or a
> + *			negative errno on failure. The frequency should be one
> + *			of @freq_table, as it is used for the transition
> + *			statistics.
>   * @exit:		An optional callback that is called when devfreq
>   *			is removing the devfreq object due to error or
>   *			from devfreq_remove_device() call. If the user

Acked-by: Chanwoo Choi <cw00.choi@samsug.com>

-- 
Best Regards,
Chanwoo Choi
Principal Engineer, Samsung Electronics
