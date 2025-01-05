Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12D21F19A;
	Sun,  5 Jan 2025 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736116642; cv=none; b=cAclPH2Ldldxz72I+kIDHTLmzV7HnyNGg5Uq4bjJxZHhVPTZ74eJ8Nro7Cru6V06r2dv4hDjpClr92qX6oCshF7hpG6VPyIgqquCqTGjkLt/5pxSyeC7i5tba9H4xu4TfNJukSowLH+eukhvCUFR1CQaixagg/nwB8ZeTDNWt8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736116642; c=relaxed/simple;
	bh=22u1XoZb5OcrBrVnpq6EpPcxYiFxTtdO6tNyG8MrsvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iBjBxNAQJvgTGLSl//cfpoypfd3No7Sjoj/DV0AqK75e1a0aqDCf2xpBSCyRtWqr9uoTRgvvBoZGy1/x5dNa0vB9Udp5tqD0LeV2XfB+5Xp6ZNMP4LLuBMBhX4m0z0fJaKuGYj8hQzy5jVzsXYIAUTtKlbI3G9+pakgR+K5k1Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mFJgj8qT; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mFJgj8qT"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216401de828so183283125ad.3;
        Sun, 05 Jan 2025 14:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736116639; x=1736721439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=IIZa7uAQTnCEAiBl4lJ8chhF36CjhlH6u2yID18KxIo=;
        b=mFJgj8qTqNXy52p0KBAGi11YNTjbOrjyg39hdQDoBgzrkEzWIT5uoWP8Vsc6MdhKCS
         aCAltuGEvqmowvddj/KiPcgvCIhx9iblTfRuTFGIBf3d/AxkJQmBpwUdRdYm4x26Vpla
         t2zgySL8KY19jwZn9fY2Pp4ByDJxFHKAvG2QhRwcKfsqlx15qxu9eMDU/vIldPYjOXxL
         l++2zWr2X/8XQoJX6T3R5QpZp++E7pcPXgqXXrGD8CT/fdKoKXSMjy/1NTtohwtlE6gX
         xOaBxx9RRsov0paJ3ed2VMyEqYHWWETCjVDPbaWDfFCCLCTADSCSAHNfJDDbl5n1+t19
         Dlog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736116639; x=1736721439;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIZa7uAQTnCEAiBl4lJ8chhF36CjhlH6u2yID18KxIo=;
        b=fowgTrQg7KFAwas7XjMKn7Pm817AQjcb8y0fjWRQvwXptuCaSL3GuLcbH33KVC6kpT
         Ml93V5hFF1w1SwB+GNV2oE8F8ROo3FxgXL78f+LVokFl6s0LGAfeBFw7VHRqvX1BWGzs
         uSclvLtFzMOvyalAMG2pWvf9q0d47Fdwg+tfp3h1KaG33JYoCpfgNvivZnw8OeI7ATfl
         E9Gb1aP8c11AkdHg8oY3UtGu/Fut3x8xELwWC9Amgx7QUxv7GRaJM06tQ9DKRA8MgXyl
         CLV++KlO+/LAju1+0YPPRAElFFQpKwGhA+3CqxG9gZIpAz+bA1dik/QstRGSjK2rne8u
         J0/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUlODgXOnAysc5ghlNiYPDLMavBP0T8JqiV2J4FTAGrNN/2Z5V4yd3f6NfRxoX2N1f7ITvHxluRhL96ZK75@vger.kernel.org, AJvYcCWnvU0dsI6FCfdBHjPG2vm3KKWeoDQ3qLHGm8bBQ3LohwJgn+7bKGzJLWu7M4chR1vqAhGr9qx7GKqXXw==@vger.kernel.org, AJvYcCX32wWvX61m5hpDp6V2yhwE50j4xJYCdtBfGUFK6qF9ZuDta0aXMcDQXiAmtG2TqudkrZPq5izETwMqJQ==@vger.kernel.org, AJvYcCXPJhTYk7oJhoX12d0AhwvvNOGTscb5ng/vxl9Ov/zvoB7Pvr9LDzPyIjiB52/xZBv2vEkJnr9rJBAZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxgMT0A3Q0W3rrphv7hffi/nnEtA71Ml4s2LZEJeo6TcFSHFFm/
	/h/IRbvEQl2lJHMp+h0unaFi/aeuqCMDG1jMd0U/101dNB+qZ8RdaVYzEQ==
X-Gm-Gg: ASbGnctu/OUFp9mFfmpcjsLc3/8bptR7JzzMMGfqkzsGsORAinduDcE7IAyUDzEsYtt
	SvyDAz3esYrq4juwYIPG3ooTtnLxCO753HTvwXt65e7zqbEfTl2YHnTOPV/o7Iusc46907hB4q1
	gMiAwQRqLmjtzoJ48i5k21iKXVm66r7csdOVD3GmAKHP4GG2zf6FcTcqswUZ7p4VcgxNqGb9gV0
	LYrIWYbfHj7sWEUuIzchYZfYjFT9bfLcdCZLk4LPyh9EKngOff1ZYTd8eu095ZrsElXo12DDq11
	Y6h/BSYrG3Av0Zan49/8t1k+RBFpyA==
X-Google-Smtp-Source: AGHT+IEoLME3aYaMTSjvvY1XKrqQdG7YFIvWgt9CY1xvD8Xcb9DOZQP+th02Fb7qPO4YSs13KV30iA==
X-Received: by 2002:a05:6a00:8085:b0:725:1de3:1c4a with SMTP id d2e1a72fcca58-72abdd3c159mr77469807b3a.3.1736116639033;
        Sun, 05 Jan 2025 14:37:19 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8486c6sm29997117b3a.85.2025.01.05.14.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2025 14:37:18 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <2d5cc90c-89a2-4af3-a3f8-2c5487d571e7@roeck-us.net>
Date: Sun, 5 Jan 2025 14:37:16 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwmon: drivetemp: Fix driver producing garbage data when
 SCSI errors occur
To: Daniil Stas <daniil.stas@posteo.net>, linux-hwmon@vger.kernel.org
Cc: Chris Healy <cphealy@gmail.com>, Linus Walleij
 <linus.walleij@linaro.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org
References: <20250105213618.531691-1-daniil.stas@posteo.net>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250105213618.531691-1-daniil.stas@posteo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/5/25 13:36, Daniil Stas wrote:
> scsi_execute_cmd() function can return both negative (linux codes) and
> positive (scsi_cmnd result field) error codes.
> 
> Currently the driver just passes error codes of scsi_execute_cmd() to
> hwmon core, which is incorrect because hwmon only checks for negative
> error codes. This leads to hwmon reporting uninitialized data to
> userspace in case of SCSI errors (for example if the disk drive was
> disconnected).
> 
> This patch checks scsi_execute_cmd() output and returns -EIO if it's
> error code is positive.
> 
> Signed-off-by: Daniil Stas <daniil.stas@posteo.net>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-ide@vger.kernel.org
> Cc: linux-hwmon@vger.kernel.org
> ---
> 
> Although I see there is scsi_status_is_good() function, which probably
> means that not all scsi result codes are errors? I don't know scsi
> protocol much, so maybe someone else can check it.
> The error code that i see when the drive is physically disconnected: 0x00030000.
> 

Unless I am missing something, scsi_status_is_good() returns true for
0x00030000, so using that would miss this and various other errors.
As far as I can see from the code, any non-zero host byte indicates
an error, and the host byte is independent of the status (in the lower
16 bit).

Guenter

>   drivers/hwmon/drivetemp.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
> index 6bdd21aa005a..fdf1d3b3b5a5 100644
> --- a/drivers/hwmon/drivetemp.c
> +++ b/drivers/hwmon/drivetemp.c
> @@ -192,8 +192,11 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
>   	scsi_cmd[12] = lba_high;
>   	scsi_cmd[14] = ata_command;
>   
> -	return scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
> -				ATA_SECT_SIZE, HZ, 5, NULL);
> +	int err = scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
> +				   ATA_SECT_SIZE, HZ, 5, NULL);
> +	if (err > 0)
> +		err = -EIO;
> +	return err;
>   }
>   
>   static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,

