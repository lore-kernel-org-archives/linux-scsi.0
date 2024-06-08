Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CCBED9;
	Sat,  8 Jun 2024 01:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717809122; cv=none; b=ebuhnWFpkYOapaIRkMyXmuh+01HHeMa0s4bbDlzGkXRnioEh4NNQPYnN57woQTvv+a3xHcicxJbgIYuIMTgpgD6Egtd6V9LWYC7rWXeBeN5jZsGGi/dN72UAsYBKviLgIh3pRsdXjkLCcU+JxTGoKkRLd2eAEc11MbNZIwRK2AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717809122; c=relaxed/simple;
	bh=h+EkJtzki3V5jwqqCQPEnmwVwniwOi6t1nE8K7ajlyc=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=u//bCSCvse3sDC0L0M0P+XBxwhl4so4bKelKSX2JVzYDNhi9WAlIuCFArJ00DIynsygzodKlQvJgEQUcHscL67Z0a7HD9vovUaf2oGE1+KZ3YkA+TeXMGFgiARU7yf8OQsUWA6sjK/yGipvkeGousECk8cQxC9HYwXVLfj57KPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fhJyKRi9; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhJyKRi9"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70421e78edcso329949b3a.3;
        Fri, 07 Jun 2024 18:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717809119; x=1718413919; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:cc:references:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcaT27ASFQz7yWtuXaouA+1bk0Uq2UvYft///b4ctjQ=;
        b=fhJyKRi9erOyKlo46/hw0o0VzjVOnuLSQuvUVTIogujVJ4fTWacrQaJSxj/Q9MSxGA
         IfgTC7g3/N2QJj1iCpUEKRMLboGQc33sCjhLY8H/bTjrqVG9eoxepslJ4WHCAhx7Vjl2
         qEAhF7E/SC0xqqCMNpf4ZautEg4hk0lm3mqXmrR52ARWViFDCO4+S5jb660GIyZ2yx7Y
         i7kPljUbSJKULV/EqkQuqJQe03qPBwtCOO7oKuNsR+jwHz4nBbuCddVHx17xeC/6soDN
         mc/5SwVYfpghasoBZjtK6ilAuVCNkd5Av/espEn0Hb3zytuoxN2gACwKO190SnOwErOE
         ph6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717809119; x=1718413919;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:cc:references:to:subject:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JcaT27ASFQz7yWtuXaouA+1bk0Uq2UvYft///b4ctjQ=;
        b=IECkvzkPcvZRV/EvN6NBJcws4OTPxJIe3U2CxXyiK0UHcD5p7SJDcn0gxnBiq69zHn
         ErFzHhspWJxr9BCegkMQRzs4SIYwP+AI/t+W3SmvP+QYqhtDMUHk7LHXwyqn9Hl3CX30
         w82ZtqBbr3REHojzaiJdaaqQrBnsmqxa0vJZA4L6YiL3lO/GUuqvCBEtdseH/f0dCUNa
         DiParQxMt5LJhkerqG2Ke7RpdvW8nuLw8Gvz74mEQQ9F1eGMiT3rG5qs2eO1fTw+oLy4
         3kFUH0X2qDd0OOYeXcMn02wiotzVh6T44blB81mKhVzvdtEpXOFpiXgoJR6bEEDDpudZ
         YTMg==
X-Forwarded-Encrypted: i=1; AJvYcCVK3ClmHN7Vf9ttE6aOXIuBpcvwA6hUXm0hn4WP7oo9cORTZLQwsKTsNnxghA959dI/uh9LIeakKe8Z+izrIKykV1luIc0GsMQGxBwADhcpeW2J06bzEiPvpOZgrvX3crWl2lbiU4kbayioN2zLOAmm+cKgvullDmQ8fa/MXt08tUuNVYaRFYxLqKVRaybeXKBpsPgVvOTeChtxAraINWO8m+tTIWxJJQ==
X-Gm-Message-State: AOJu0Yz4r4o48dwg7QlA+G4KB8ShWB+WgnowxMXxoPCIt/PSmzmfzqTu
	UAu+vtu0/u8y+4XX9QvOHD6IOEhBXMszDD0PUU6R0Y6vlFvujWhigY/GIiFJ
X-Google-Smtp-Source: AGHT+IG2VoxEIZRtiZa91EW7LyiLX93dO8ax0Mxo186iN+pLzQWOnoUuSO36PvSt83EOFjcMAC0OFg==
X-Received: by 2002:a05:6a00:1146:b0:702:2749:608e with SMTP id d2e1a72fcca58-7040c3ae1f5mr5386476b3a.0.1717809119392;
        Fri, 07 Jun 2024 18:11:59 -0700 (PDT)
Received: from [10.1.1.24] (222-152-175-63-fibre.sparkbb.co.nz. [222.152.175.63])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7041043b2a5sm1640542b3a.148.2024.06.07.18.11.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2024 18:11:58 -0700 (PDT)
Subject: Re: [PATCH] scsi: add missing MODULE_DESCRIPTION() macros
To: Finn Thain <fthain@linux-m68k.org>,
 Jeff Johnson <quic_jjohnson@quicinc.com>
References: <20240607-md-drivers-scsi-v1-1-17ae31cc4fe5@quicinc.com>
 <82cdd602-8faf-5cc0-c0b4-87ff1d820474@linux-m68k.org>
Cc: Khalid Aziz <khalid@gonehiking.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
 James Smart <james.smart@broadcom.com>,
 Ram Vegesna <ram.vegesna@broadcom.com>,
 Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
 "Juergen E. Fischer" <fischer@norbit.de>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
From: Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <0d7b4fcd-acaf-bb07-97f1-dcb729b48baf@gmail.com>
Date: Sat, 8 Jun 2024 13:11:48 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <82cdd602-8faf-5cc0-c0b4-87ff1d820474@linux-m68k.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jeff,

Am 08.06.2024 um 12:52 schrieb Finn Thain:
>
> On Fri, 7 Jun 2024, Jeff Johnson wrote:
>
>> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
>> index 742625ac7d99..4eb5770aeef5 100644
>> --- a/drivers/scsi/atari_scsi.c
>> +++ b/drivers/scsi/atari_scsi.c
>> @@ -894,4 +894,5 @@ static struct platform_driver atari_scsi_driver __refdata = {
>>  module_platform_driver_probe(atari_scsi_driver, atari_scsi_probe);
>>
>>  MODULE_ALIAS("platform:" DRV_MODULE_NAME);
>> +MODULE_DESCRIPTION("Atari generic SCSI port driver");
>>  MODULE_LICENSE("GPL");
>
> "Atari NCR5380 SCSI driver", please. I don't think the word "generic"
> applies here. It was a reference to the "generic NCR5380 driver by Drew
> Eckhardt" from which specialized drivers like this one were derived.

Correct - and "Atari TT/Falcon NCR5380 SCSI driver" would be even more 
precise.

The generic Atari disk interface was the ACSI interface (somewhat 
similar to SCSI, but a lot simpler).

Cheers,

	Michael Schmitz

>
>> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
>> index f6305e3e60f4..1bef131664e0 100644
>> --- a/drivers/scsi/g_NCR5380.c
>> +++ b/drivers/scsi/g_NCR5380.c
>> @@ -110,6 +110,7 @@ module_param_array(card, int, NULL, 0);
>>  MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC3181E, 4=HP C2502)");
>>
>>  MODULE_ALIAS("g_NCR5380_mmio");
>> +MODULE_DESCRIPTION("Generic NCR5380 driver");
>>  MODULE_LICENSE("GPL");
>>
>>  static void g_NCR5380_trigger_irq(struct Scsi_Host *instance)
>
> "Generic NCR5380/NCR53C400 SCSI driver" please.
>
> This driver actually describes itself as "generic generic NCR5380 driver"
> which appears to be a joke. The term "generic" was used to mean universal
> i.e. intended to cover every ISA card implementation.
>
>> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
>> index 625fd547ee60..82d8b8f8293f 100644
>> --- a/drivers/scsi/initio.c
>> +++ b/drivers/scsi/initio.c
>> @@ -2939,6 +2939,7 @@ static void initio_remove_one(struct pci_dev *pdev)
>>  	pci_disable_device(pdev);
>>  }
>>
>> +MODULE_DESCRIPTION("Initio 9100U(W) driver");
>>  MODULE_LICENSE("GPL");
>>
>>  static struct pci_device_id initio_pci_tbl[] = {
>> @@ -2961,4 +2962,5 @@ module_pci_driver(initio_pci_driver);
>>
>>  MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
>>  MODULE_AUTHOR("Initio Corporation");
>> +MODULE_DESCRIPTION("TBD");
>>  MODULE_LICENSE("GPL");
>
> There are now three MODULE_DESCRIPTION macros here.
>
>> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
>> index a402c4dc4645..f74231ca29e5 100644
>> --- a/drivers/scsi/mac_scsi.c
>> +++ b/drivers/scsi/mac_scsi.c
>> @@ -550,4 +550,5 @@ static struct platform_driver mac_scsi_driver __refdata = {
>>  module_platform_driver_probe(mac_scsi_driver, mac_scsi_probe);
>>
>>  MODULE_ALIAS("platform:" DRV_MODULE_NAME);
>> +MODULE_DESCRIPTION("Generic Macintosh NCR5380 driver");
>>  MODULE_LICENSE("GPL");
>
>
> "Macintosh NCR5380 SCSI driver", please.
>
>> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
>> index 7ab000942b97..c4a88f673183 100644
>> --- a/drivers/scsi/sr.c
>> +++ b/drivers/scsi/sr.c
>> @@ -68,6 +68,7 @@
>>
>>
>>  MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
>> +MODULE_DESCRIPTION("TBD");
>>  MODULE_LICENSE("GPL");
>>  MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR);
>>  MODULE_ALIAS_SCSI_DEVICE(TYPE_ROM);
>> @@ -1007,4 +1008,5 @@ static void __exit exit_sr(void)
>>
>>  module_init(init_sr);
>>  module_exit(exit_sr);
>> +MODULE_DESCRIPTION("SCSI CDROM driver");
>>  MODULE_LICENSE("GPL");
>
> Three macros here also.
>
