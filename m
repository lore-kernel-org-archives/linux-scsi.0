Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0861E86E;
	Tue, 14 Jan 2025 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866199; cv=none; b=CFQiAzryMi2OluJGC9+JIYDlsxUWlAUsa+iama3U0kHZf6gWH1hme0swPu+kPcKa9IS+/E27rNLFgw4zCHZDMf6x4iiJyYcFjyiB1x37K09L9J/rpRGpw/6x5bWfltQ5IDraEnNzJ6C61wJDBfu2OB7/xUwDLokocvfC1vZEzeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866199; c=relaxed/simple;
	bh=Pxh3kQE9DqemRRY5A/xlc1bC8PF7bNCfxT8IqCph1Eg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2FIdNYDqvEpyaqxn0EVghjn0GHJy12j+xGgvO669TeHFm8sqZZjw38V+e5FGQpd/QuPOmvdinRhRyUXyDjugyB7iGts5LqEryoLQii41vwW/+ATAVEIW30ucC2cHGaciNXQZ0P8IUQJrUxrSprLB7+AQ/NXjxtxflF6uvSEGw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZydzXk5S; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZydzXk5S"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21a7ed0155cso96336875ad.3;
        Tue, 14 Jan 2025 06:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736866197; x=1737470997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Kau0WwvXt8Nt9vi/G17hGuAEyvknENrp4uqh1eI5TwA=;
        b=ZydzXk5SMycsg0OAUt7lDTOOrMS23zwHMk+wMN9kQY+75xGRqxfa+2IuBLqrYOcrtZ
         KlT2aBVdhclKEPDjqkq8cFP5wQdqqbLbLLPypsE+ySW6+S63vhpQc9nVvj/RI854E1Ju
         xk0g9ffddkUl1CviMFjeMGkNy4FRAQwJYVv4kdgDe3zwI/EUWhfkJrjjd/i9RA5EONbm
         YZZ5/Z0/D4hLdp/R8RKvntfNchxLh8Llra4cFAke8DijMeDNYXJqxeI+WbR7TGerrPn8
         u7UdvhepgC1HAdazwLH8esT6wtooTD2joBD+AqdwX5l9S/9qO4fa9HFkdm0MchFTeT4O
         WOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736866197; x=1737470997;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kau0WwvXt8Nt9vi/G17hGuAEyvknENrp4uqh1eI5TwA=;
        b=fAkW5y0cYrwrlH+Y5E8PZY80Ix4DhzZqJo3/irF1zejEFTPMz6edqZpq0NHyQFEUO9
         6BZgNiNVoaqI8KaJlHQuBywD7LH2PuL3r5fbVM7EBLOwmotPpgUpm454VW2AzXgjX8Zi
         /42as8brBLPbdkNtMi6w0E4S6NDQd+loHhRnzKOp8AELqj4tCIna9mjeUzTFzjizyPiD
         sgQwDxta7tW5TYoeiH/kuXNr92Qvxn1F04WOut0nWp6vVO5VCR9P+a9Wr5kaZfxTT88A
         aOdIyb6Xne2Se47orab8U8EDsINWFgvRuqiA3yCBt9sgvATZX162GLE/qWqNHGkgD52p
         vSKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKhA/5rSBTfhEwVUE3TTCuR1CBgTGFr0kkTPw/4EZbkxDRnU6dd4eaJcfsGbOlPeW3MeJ4YDgi3xyKdUU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyE2HFNqEpD83hwL3S70L9HQpO7w23VaYEpNkC/moxFEXbMfrn
	ZRf54pj4/HrUgWQeldNQeB7ZS3/ndPwSCGltR76xU4ZMHb9/4O1r
X-Gm-Gg: ASbGnctGP6R+hU/7uuj3Hq7UD7Vsd1LK7ZSbONCuSgsLXuQr0rcD9XR09WJHFQ+4a9D
	uOJqh1qR4BwczjGNhv6HIObhp6m+AYHJB6lt46CWj+W+AU6+6ZP6rnVOvTUhiB3yvgRbo9QUMl5
	hP4Lv3lMqYG8201BtPAJ2DmlkqE77Z5x/Vw5HwKsSKB3JCCXjPg7EyMqog4ulRgevRinu/SqzNr
	HsCKUXzu9jY+ujbfL0Cke290EjmlQLqcWPbqvMV5V7hkubbKS+j+c38ALeIGEacnrhxmK71iehJ
	oEqayArWQ/RFomGORZIs0c2Vnwnyiw==
X-Google-Smtp-Source: AGHT+IHxJO8RdlBMWoVyXnUWmZ35/shfzvWpFEJNhRWrIqV5hH4qsUp2Lh4SieDDHg76VSuVr/ZF2w==
X-Received: by 2002:a17:902:f54e:b0:215:5935:7eef with SMTP id d9443c01a7336-21a83f5509cmr452489505ad.22.1736866197193;
        Tue, 14 Jan 2025 06:49:57 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm68227105ad.139.2025.01.14.06.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:49:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <2f2fe6f6-cc10-48fc-8df6-b82e4ba22247@roeck-us.net>
Date: Tue, 14 Jan 2025 06:49:55 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: hwmon: Add missing ABI documentation
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bart Van Assche <bvanassche@acm.org>
References: <20250114093512.151019-1-avri.altman@wdc.com>
 <20250114093512.151019-3-avri.altman@wdc.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250114093512.151019-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/25 01:35, Avri Altman wrote:
> This commit adds ABI documentation for the UFS hwmon driver, detailing
> the sysfs attributes exposed by the driver. It includes the missing
> temperature notification entries, that were added back in 2021.
> 
> The following sysfs attributes are documented:
> - /sys/class/hwmon/hwmon*/temp*_input
> - /sys/class/hwmon/hwmon*/temp*_crit
> - /sys/class/hwmon/hwmon*/temp*_lcrit
> - /sys/class/hwmon/hwmon*/temp*_enable
> 
> While at it, update a missing reference to the ufs ABI doc in the
> MAINTAINERS file.
> 
> Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notification support")
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   .../ABI/testing/sysfs-driver-ufs-hwmon        | 31 +++++++++++++++++++

The hardware monitoring ABI is documented in ABI/testing/sysfs-class-hwmon.
It does not make sense to document hwmon driver sysfs attributes per driver
unless there are non-standard attributes.

Guenter

>   MAINTAINERS                                   |  2 ++
>   2 files changed, 33 insertions(+)
>   create mode 100644 Documentation/ABI/testing/sysfs-driver-ufs-hwmon
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs-hwmon b/Documentation/ABI/testing/sysfs-driver-ufs-hwmon
> new file mode 100644
> index 000000000000..a27a108ffd28
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs-hwmon
> @@ -0,0 +1,31 @@
> +What:		/sys/class/hwmon/hwmon*/temp*_input
> +Date:		September 2021
> +KernelVersion:	5.16
> +Contact:	avri.altman@wdc.com
> +Description:
> +		Temperature input value in millidegrees Celsius.
> +		Read-only.
> +
> +What:		/sys/class/hwmon/hwmon*/temp*_crit
> +Date:		September 2021
> +KernelVersion:	5.16
> +Contact:	avri.altman@wdc.com
> +Description:
> +		Critical temperature value in millidegrees Celsius.
> +		Read-only.
> +
> +What:		/sys/class/hwmon/hwmon*/temp*_lcrit
> +Date:		September 2021
> +KernelVersion:	5.16
> +Contact:	avri.altman@wdc.com
> +Description:
> +		Lower critical temperature value in millidegrees Celsius.
> +		Read-only.
> +
> +What:		/sys/class/hwmon/hwmon*/temp*_enable
> +Date:		September 2021
> +KernelVersion:	5.16
> +Contact:	avri.altman@wdc.com
> +Description:
> +		Enable (1) or disable (0) this temperature sensor.
> +		Read-write.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 838d3038e1ea..71a69551aee2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24070,6 +24070,8 @@ R:	Avri Altman <avri.altman@wdc.com>
>   R:	Bart Van Assche <bvanassche@acm.org>
>   L:	linux-scsi@vger.kernel.org
>   S:	Supported
> +F:	Documentation/ABI/testing/sysfs-driver-ufs
> +F:	Documentation/ABI/testing/sysfs-driver-ufs-hwmon
>   F:	Documentation/devicetree/bindings/ufs/
>   F:	Documentation/scsi/ufs.rst
>   F:	drivers/ufs/core/

