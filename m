Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6365C40865
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 14:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709907589; cv=none; b=pu3+gCzTrh6ccaH8gagL7huylGB5kq51aGMWjG3O/0e0hWjSnYE5qa2Aruc37IMlbtsInXT88XQ4bs+kQ2LSp0LQVSbSfub4xmWyNxdshEBjCC17Gl2gdD6IYKuHkJkVbZLljUiLRyQQ/Cth56RmkJ8flMtud2WKoBiaRZAfeS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709907589; c=relaxed/simple;
	bh=FRnChMNHqU9nKaHsm53ayw24IFI4WqiXXuruvqv3Gk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rw6JpRD44dOqRQj9pNGrX/k9QvuU6kkiaFr2s6otlSDY24Tliuzsi1W43J1arpx2l94LScyiWTyA8yp2TeC7OYXMwWsx+BFmuaxrBxDJ8WvStZvU/weyH4DcztYSltCb1aS92ggXeZoD9ZIACJFIEaX6BcfhNxPoc0CMcF6SdBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33df8203a08so303988f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Mar 2024 06:19:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709907586; x=1710512386;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AdV6TZveSeGX04cT7SBmu58cwbWGwgje7nGBW5gWx6A=;
        b=YNePKgjMI2KUrUIZ+lINfYiMk9D6IJ0PqnUEk1I1P1GJI+DaIRAzmLA1noSottaSBB
         b0JCN+OfcNKB3Ll3PzmMCDaZ2RIQuVIj11LZKr3ZPDXmQ68qu0r3nSDSoznsRXaTniBi
         GR92toHYnOfiprlIaUrsOgIld3O3InDmpufqLJSbKMyWm5cHBdiyQDhN439C/2PX5mA9
         1A23to6iePdPL6E8naOibTWJjxa/TRQwVtBpJc9UQ81MfiiYdhInAGqBd5F1orfNnVla
         zbS7Tb4MhPareIRKaNck03pX7RP/Q0Lgd58T2SJUW4q/c0x6emMRsUV6V52Rnj9QTE03
         HB+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWN0yx3nSWy2/kkuRlDOl/8nOw/eWbcM8E1lBVkD/DWgl8ZsIx+Aa/lMSeNeVYxl81tUKStaiJSY7n37YGH+T3jitE6/qRLcKBT2A==
X-Gm-Message-State: AOJu0YxDEXJ7KWV2I+pOeQRSh2UJkziZBRv4MgdGJ1QqmPmBHBiR0lDz
	OVmRJFBI4BLmUb7s5ofR+EItbiTTExdIa90BjIPWyQrSZdEe2Cg2
X-Google-Smtp-Source: AGHT+IFrjukXj/51Y6pNIhp1LInIpZlj/CUHPTL1zdB1dXy5yaBrgI9YScz2AUfkWY5bUbGHgW8Wfw==
X-Received: by 2002:a05:6000:1b0f:b0:33d:568f:8986 with SMTP id f15-20020a0560001b0f00b0033d568f8986mr1451599wrz.2.1709907585685;
        Fri, 08 Mar 2024 06:19:45 -0800 (PST)
Received: from [10.100.102.74] (46-117-80-176.bb.netvision.net.il. [46.117.80.176])
        by smtp.gmail.com with ESMTPSA id v7-20020a5d59c7000000b0033e475940fasm10768889wry.66.2024.03.08.06.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Mar 2024 06:19:45 -0800 (PST)
Message-ID: <32e337ef-a041-4b73-a6f6-211458a5c71e@grimberg.me>
Date: Fri, 8 Mar 2024 16:19:44 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] nvme-fc: FPIN link integrity handling
Content-Language: he-IL, en-US
To: Hannes Reinecke <hare@suse.de>, hare@kernel.org,
 Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, James Smart <james.smart@broadcom.com>,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240219085929.31255-1-hare@kernel.org>
 <1dfa9a4e-e4a2-4d48-b569-85e48ce4311c@grimberg.me>
 <1c3eea31-b80f-4b95-ab15-ac42f7c45c16@suse.de>
 <7ff7c9cc-6b02-4adc-9b78-8bab26341049@grimberg.me>
 <0b18f1f9-5011-46f4-a0a1-a69cd54bfc88@suse.de>
 <2b0bdbfb-1bff-405a-8f95-163a99022d94@grimberg.me>
 <4f3ee04a-daeb-4813-9f08-6450cffa1d70@suse.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <4f3ee04a-daeb-4813-9f08-6450cffa1d70@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 08/03/2024 16:09, Hannes Reinecke wrote:
> On 3/8/24 11:38, Sagi Grimberg wrote:
>>
>>
>> On 07/03/2024 14:13, Hannes Reinecke wrote:
>>> On 3/7/24 13:01, Sagi Grimberg wrote:
>>>>
> [ .. ]
>>>>
>>>> stopped is different because it is not used to determine if it is 
>>>> capable for IO (admin or io queues). Hence it is ok to be a flag.
>>>>
>>> Okay.
>>>
> But wait, isn't that precisely what we're trying to achieve here?
> IE can't we call nvme_quiesce_io_queues() when we detect a link 
> integrity failure?
>
> Lemme check how this would work out...
>
>>> So yeah, we could introduce a new state, but I guess a direct 
>>> transition
>>> to 'DEAD' is not really a good idea.
>>
>> How common do you think this state would be? On the one hand, having 
>> a generic state that the transport is kept a live but simply refuses to
>> accept I/O; sounds like a generic state, but I can't think of an
>> equivalent in the other transports.
>>
>
> Yeah, it's pretty FC specific for now. Authentication is similar, 
> though, as the spec implies that we shouldn't sent I/O when 
> authentication is in progress.
>
>> If this is something that is private to FC, perhaps the right way is 
>> to add a flag for it that only fc sets, and when a second usage of it 
>> appears,
>> we promote it to a proper controller state. Thoughts?
>
> But that's what I'm doing, no? Only FC sets the 'transport blocked'
> flag, so I'm not sure how your idea would be different here...

I know, I just came a full circle with our discussion :)
