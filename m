Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8769C28684;
	Fri,  6 Dec 2024 06:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733467933; cv=none; b=OxuyD5bS4G/CRyMkmDNLTH2DQcmUpF4MS7uY3gmZ2EsOlBl2lGPV/sYVC9sNIi157Sk/P5Jr4/eygpPeqRLbpyhqj433MEe8hlPTHPcQIg1gxEm1edrrRF9AeHoOPJbtRdGbWI/11TVWOXpYrcT6tsloQt+FjQ/mp3Agmx2hL1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733467933; c=relaxed/simple;
	bh=S7IY/owPDwKdEJDzdHTsOPr/yf7W+FvrIJ7+75tCzBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PrQWnm2Y2Qo4NoF7OIzFPU8u3CXMn29GE5gDtOW34bd2dLeqzQ6lYSNnJqr/S6SxdCMz/NkZ6pBGeS1jbhUdWlOE04AunFaBxlqkeUQYvlwS0BQg3Qdgr1Sj2vRUVMGGgjcHJLTvwH/EJYOkQiADiVfQh7dvyn2nAyUs5mtcwEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QE95K1p2; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QE95K1p2"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21568166415so13649155ad.2;
        Thu, 05 Dec 2024 22:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733467932; x=1734072732; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5n8xjg3h51rfaaD6/oxW7Uy/DgrSQdXONvlxuue9ArQ=;
        b=QE95K1p2T+ukd8+E9HN0FHyfBV9v5WZTnwWrV5MPJYhkmDcoNMVXfzjE69AHN7yxeU
         vwwWPQ+ZuwQnJrWM3rAbU8LdxvCktZM4EEKVhZQTxs1Tmzy6z98kVaClLUo8tdlaoDMh
         OxIYdOJscxO88HkKYFAXPM/9Eb3YOUjh5gjwP0j/B6asyBRm9CalbaSfTleSQST1BNdt
         wJfU22ezfdjtpgM5AzMU1D6VU1P9slzcLivvyQIdyrR5Cq7yhYcIvxHGrDOwYq74KU3l
         MEhV0oscB6O/wOaoJDFUBaWx1z5k9ZSgIBNcGL1WSrCXEqIj/QG3rSMJk25FhK6skIZY
         sgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733467932; x=1734072732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5n8xjg3h51rfaaD6/oxW7Uy/DgrSQdXONvlxuue9ArQ=;
        b=csaSeQ5vt8WfMfXJJXSVqK7bxqAGAoFgl/zx03dXiDi2xnD2BWnYr4dWTvMpYF7SsJ
         QA7wH/kzpWVm4xnq7gicOibY+cPZeWB5nLXa0AG8r3VRRUXqbVVcHJ6wXBGj6W+N2ziH
         UrcBus5LbjGuWz/9JXgRS9wGWiYdWqbxEpFKKK+BK6Wij9fWllzcAnbqi/nPp7kZVdog
         W6MPVgriU/uQL+sY9pObg1z+02gF5ux5tuE98SxNFnDBzjcXavlAX6OEZHgYuJ4OUGft
         +uYOZIXM0jEzB55tTfcgE4xWIkYHs31leDvnwL2w7NJmiLc+dU/67nvY6jl2xE9EkSTk
         sRSg==
X-Forwarded-Encrypted: i=1; AJvYcCVlIm7qLU8UKY3lvi2C0kT4SdGv8qL51pcQxp1CY0IRRLXT3NXnJ8ojqtlUnE9l3iFwJdgZCrth4wf3hmw=@vger.kernel.org, AJvYcCWGvqyUuEmR7hPVeh0/yv6wc+e84y4Q4T0M5tQb2MMfBRVkBk5XRBPVdm+8pkRvUTQGkmzXB4jY57LcWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgLIMAm+9RgQBpv/w8bVhdLL0vCZN7+4x7oD3FzVnPgtaenTkJ
	vtRqokaK1DY38CowZiykMNT+2Fu1LjKZbOugrQ6gw7EjqktainqmYiRcVw==
X-Gm-Gg: ASbGnctqzMpg2qfYn6KOF2ycKcdD78SGX+9NlR0S0jJHxK4ZH9p/RxEJWxApCxhobHg
	Yx0kPmVtR8vwhG6SxijnSIFQ2OagH9sKuWNfOS9lczEd6PjeZBSE66A+QhGBVI8/KaGXAW9IlBw
	M6lk9FXjGM6HrQpMFCn07W1dVu4NnHpmSRAHctDYVbH4S/bI2wddwJiy2MC5s1A/0owXew8UU0X
	IyjC5wrmV9wYQYXnEupeO2FvOeScTo7K9sz+airZKc3itaeKiYsRACRxnVDr/iY8FwGBhm2I658
	Bh04WvWIIp2WgpcHr3z2MNRICr1ByqmmdEHrafk=
X-Google-Smtp-Source: AGHT+IEF5+GlCh6SXP+YIUS50LFEPeIptVkgi0j6qsXkg0mfIuk0AAlHZ+94aRnsORw+/YVDDjlA+w==
X-Received: by 2002:a17:903:41cc:b0:215:5437:e99f with SMTP id d9443c01a7336-21614da3f42mr29333655ad.36.1733467931706;
        Thu, 05 Dec 2024 22:52:11 -0800 (PST)
Received: from ?IPV6:2409:40c0:11a8:4b75:cc65:3de3:4b81:a899? ([2409:40c0:11a8:4b75:cc65:3de3:4b81:a899])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8ef9e21sm22392725ad.160.2024.12.05.22.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2024 22:52:11 -0800 (PST)
Message-ID: <47bc4dd7-de7e-4c97-9e1b-2727da4f5d30@gmail.com>
Date: Fri, 6 Dec 2024 12:22:01 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: fix slab-use-after-free Read in sg_release
To: "Martin K. Petersen" <martin.petersen@oracle.com>, dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
References: <20241120125944.88095-1-surajsonawane0215@gmail.com>
 <173336487634.2765947.1842407236657188629.b4-ty@oracle.com>
Content-Language: en-US
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <173336487634.2765947.1842407236657188629.b4-ty@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/24 07:47, Martin K. Petersen wrote:
> On Wed, 20 Nov 2024 18:29:44 +0530, Suraj Sonawane wrote:
> 
>> Fix a use-after-free bug in `sg_release`,
>> detected by syzbot with KASAN:
>>
>> BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30
>> kernel/locking/lockdep.c:5838
>> __mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:912
>> sg_release+0x1f4/0x2e0 drivers/scsi/sg.c:407
>>
>> [...]
> 
> Applied to 6.13/scsi-fixes, thanks!
> 
> [1/1] scsi: sg: fix slab-use-after-free Read in sg_release
>        https://git.kernel.org/mkp/scsi/c/f10593ad9bc3
> 

Thank you for applying the patch and for the update.

Best regards,
Suraj Sonawane
