Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEEF604AD;
	Mon, 29 Jan 2024 12:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706530512; cv=none; b=kqYZqBlGnDoXAfRw920j7ig3FnHRnurUQWW6IFQccWNSuKDmyhkSWPnwKwvlsCm2kJiDwb229UlajecWHYIOAAtPdZ0AGcWUmvLG8S2/RSjfqvQdHKATtZN+YXD6SBZtNo0ABAb+ELS1ZQ8ifTlwXizJErc4Q9tSPisYipIPWlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706530512; c=relaxed/simple;
	bh=Eo2Kxb92XeztQUPeoN498N3753cx6hubmHDODcTPIW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJXyCGtRJXMj/YJmbxDffoRs97kYPdq/riWAPtRS7TUz9lYHgj3Y8IyZw8/i3Kg8KK+/AJX50UjSJbok3yGzfxA7u/bGD4K2kunIFcxuPAPCJqq61SnRgBIn0CLT9F0K1+am5r15c0D29qYzXbaalaDsFUL5H/sh6gjFLUwY7h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Snrnfztg; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Snrnfztg"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2cf2fdd518bso22397421fa.1;
        Mon, 29 Jan 2024 04:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706530508; x=1707135308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mqRoSHyswOJrlTJyBofvgWzOmdNKPgyLvJaTfIS9prk=;
        b=SnrnfztgURp+QLjcXJ2z3JfxL9b6eRpRdeHShVSa00B9pz2O94adu/F/HiY9Qlef4S
         C0WES3sMmvyFFo2/bvXSwY95TlYlwi4ySDszUQ+yYpVVLxPgpiJxJuiSJRWFYr22Ei21
         qdDOhZtiM7MzcPR1iZkBFLZov9+M4T5Q+JSzJjI9tcscJ6OiflVkUVSs0eMaYpR19znZ
         uiHkxyqebUKTtH8HbLn3cL9IpPK7jdPuyGuIUZHo6Zbcy1CunVRDT6fN3d++fv2IyRDl
         3QcTimtvWdmWJV77SxvRnE4+V4vRhKbbhbKK9wUqbHQjHNWcu/K9rC9iIUESYWSIa80x
         kKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706530508; x=1707135308;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mqRoSHyswOJrlTJyBofvgWzOmdNKPgyLvJaTfIS9prk=;
        b=wjuKDMuTxEfb6PR2S/NOfbUSyyy6ZO+LAoll/rK/MCslOloCNWLfQSXFtmwRK305V7
         lnqSwu0IOemypIAuazNXBIqNYdw4OyZHSNzr54L8dvIsM17JxnbQP6V8go/r5sv8dqcf
         31jCSWTY8PuVYtMIrTAgDot3hQTqwhOTHDPdhmIhAk6/fsArfAYElqahKCAqw/pzgS5c
         HpBVzwqjVltw9LH0+pW11ELnT/riNMgtD8le8zKBuKWb9UJRKs1wlq5PIP7oyCVq1lBo
         p/7JauUpUd/rlOhJSUBM/mqWakZg69PddyTprrRfD+5s4Ogz6/I3TA21my9Kz6QGryRm
         Q4hw==
X-Gm-Message-State: AOJu0YzxBFurz8CGATR5/SdluTInxTJtUjljkPDvtd6H9N9pzDjx1Kox
	Feg5lEesEAMEUltD/xVx2HH8BPhvtDl5Nfh1NYp7o1x9J3TAd4FX
X-Google-Smtp-Source: AGHT+IG50z8kEbQOHaMn9jr1tik/GAHe/2TiUuGkV/slAUo/ZwxFfMqkPXrVDqnzyfl1Yclt6/2v8Q==
X-Received: by 2002:a05:651c:169b:b0:2cf:1033:c745 with SMTP id bd27-20020a05651c169b00b002cf1033c745mr3250420ljb.51.1706530507932;
        Mon, 29 Jan 2024 04:15:07 -0800 (PST)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id ba8-20020a0564021ac800b0055f2af9b01bsm5102edb.17.2024.01.29.04.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 04:15:07 -0800 (PST)
Message-ID: <bb51d22e-5895-4d7f-af09-38cd9609fcb1@gmail.com>
Date: Mon, 29 Jan 2024 13:15:06 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] usb-storage,uas: use host helper to generate driver
 info
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, oneukum@suse.com
References: <20231103201709.124372-1-gmazyland@gmail.com>
 <20231105182047.166007-1-gmazyland@gmail.com>
 <2024012744-ungreased-retention-4e84@gregkh>
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <2024012744-ungreased-retention-4e84@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

On 1/28/24 02:50, Greg KH wrote:
> On Sun, Nov 05, 2023 at 07:20:47PM +0100, Milan Broz wrote:
>> The USB mass storage quirks flags can be stored in driver_info in
>> a 32-bit integer (unsigned long on 32-bit platforms).
>> As this attribute cannot be enlarged, we need to use some form
>> of translation of 64-bit quirk bits.
>>
>> This problem was discussed on the USB list
>> https://lore.kernel.org/linux-usb/f9e8acb5-32d5-4a30-859f-d4336a86b31a@gmail.com/
>>
>> The initial solution to use a static array extensively increased the size
>> of the kernel module, so I decided to try the second suggested solution:
>> generate a table by host-compiled program and use bit 31 to indicate
>> that the value is an index, not the actual value.
>>
>> This patch adds a host-compiled program that processes unusual_devs.h
>> (and unusual_uas.h) and generates files usb-ids.c and usb-ids-uas.c
>> (for pre-processed USB device table with 32-bit device info).
>> These files also contain a generated translation table for driver_info
>> to 64-bit values.
>>
>> The translation function is used only in usb-storage and uas modules; all
>> other USB storage modules store flags directly, using only 32-bit flags.
>>
>> For 64-bit platforms, where unsigned long is 64-bit, we do not need to
>> convert quirk flags to 32-bit index; the translation function there uses
>> flags directly.
>>
>> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> 
> I see the need for this, but why now?  We haven't run out of ids yet
> have we?  Do we need to add another one?

I had a patchset that needed a new flag; that was the motivation.
However, after a discussion with SCSI people, it needed to be done differently,
and I had no time to rewrite it yet.

In the meantime, the flag transition patch was split from the series.

If you want to merge it now, I can easily rebase & fix gitignore issue.

Or it can wait for the next first real user.

Just I have spent a lot of time with this, so no need to repeat this exercise, though :-)

Thanks,
Milan
  
> Also, after building, I get the following files marked by git as needed
> to be added to the tree, so perhaps you also need a .gitignore file:
> 
> $ git status
> On branch work-testing
> Untracked files:
>    (use "git add <file>..." to include in what will be committed)
> 	drivers/usb/storage/mkflags
> 	drivers/usb/storage/usb-ids-uas.c
> 	drivers/usb/storage/usb-ids.c
> 
> thanks,
> 
> greg k-h
