Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FC010E9;
	Wed, 17 Jan 2024 01:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705454513; cv=none; b=TvMzbKtRh99mEghwaFO2z6eVklclgpynkdjjJRaK1gMIWIiWONBQXwRpmAfn6XaovYepUz6iv0jTp1rCqNvvWDKWz9tjs4KdKflgVuN4iJ1QcIUWm/3NcGwkDKYiZ4kuC7zY/KfZk4vH38tOJGz4EkjgKRJB40LnREk2b87hgjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705454513; c=relaxed/simple;
	bh=WyI4PKWODctOuUEglA4Q1X3zfzwBCd7UmziYNeqb3Dg=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=hMN9WA7xaAeT2vZeax3rIECH6red/mPBlDDqi6MOZPm+1/10wsWYHja4oYpzce5rS4As+1SpvJsDjyP3fJbQ9mAh2WIvoUurobdGH/NkDaxv80GnBQ4c1h44Js56SFdo7oVOoE+61fmHWF8w9pkOEW4ROIR/q72D3vBHcQtBTC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6db81c6287dso2143368b3a.0;
        Tue, 16 Jan 2024 17:21:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705454511; x=1706059311;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gb6SX3T6t7XN0s2imQMt+9x7IH416QzU3AT9JpDJn+U=;
        b=tPqob2cVTD+NY9m/yAHd0HkpZmR5TL9kf9KGFNIjs2ir6RMYoPCwklf/i9Pv/wLUgA
         VYVqaNSRwOvQ+3Z1XOE9stTYZLqINdrJTzdrne3EwJlv1v5Pqyz2790N4UdlQ25Y2Clp
         ef9kWp6wBSjPaBS9u19sPIBDxB1EsJI3r46foUwsxp525/WNmhQmlJsZWt43rfbrc2N+
         h0rOCQW4DRnJpcbLxafrKoufE9c0d0+8JGMPy1rovjkviVB+sOozwJ06pzOVBPgXBdpH
         qDEt3wWexTTrik/TsfOE0J3ZtksblOja5WLmz40GRuEOSWzVG5LXoxL76vHYkr8GcC1S
         UsWQ==
X-Gm-Message-State: AOJu0YzCSebreap+4ZDtX9HzXyvcH0Mut3G0rvfbZdhjFrU4eXq7Q4et
	fUtss7Jm5YoX9Boexn4beRI=
X-Google-Smtp-Source: AGHT+IHQtIiqkOE1p4vpwtBpPQgd9t0yN4o2W6HSHuJlqYOLTZHKMW6+7NDdyA3Wj59PEg0m9wvwiQ==
X-Received: by 2002:a05:6a21:3399:b0:19b:42ea:314f with SMTP id yy25-20020a056a21339900b0019b42ea314fmr108129pzb.16.1705454511265;
        Tue, 16 Jan 2024 17:21:51 -0800 (PST)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id y12-20020a62b50c000000b006dab86e675esm211486pfe.185.2024.01.16.17.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jan 2024 17:21:50 -0800 (PST)
Message-ID: <a6e6859a-eabf-437a-b81f-d47c3365498f@acm.org>
Date: Tue, 16 Jan 2024 17:21:49 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/24 15:34, Damien Le Moal wrote:
> On 1/17/24 03:20, Bart Van Assche wrote:
>> File system implementers have to decide whether to use Write or Zone
>> Append. While the Zone Append command tolerates reordering, with this
>> command the filesystem cannot control the order in which the data is
>> written on the medium without restricting the queue depth to one.
>> Additionally, the latency of write operations is lower compared to zone
>> append operations. From [2], a paper with performance results for one
>> ZNS SSD model: "we observe that the latency of write operations is lower
>> than that of append operations, even if the request size is the same".
> 
> What is the queue depth for this claim ?

Hmm ... I haven't found this in the paper. Maybe I overlooked something.

>> The mq-deadline I/O scheduler serializes zoned writes even if these got
>> reordered by the block layer. However, the mq-deadline I/O scheduler,
>> just like any other single-queue I/O scheduler, is a performance
>> bottleneck for SSDs that support more than 200 K IOPS. Current NVMe and
>> UFS 4.0 block devices support more than 200 K IOPS.
> 
> FYI, I am about to post 20-something patches that completely remove zone write
> locking and replace it with "zone write plugging". That is done above the IO
> scheduler and also provides zone append emulation for drives that ask for it.
> 
> With this change:
>   - Zone append emulation is moved to the block layer, as a generic
> implementation. sd and dm zone append emulation code is removed.
>   - Any scheduler can be used, including "none". mq-deadline zone block device
> special support is removed.
>   - Overall, a lot less code (the series removes more code than it adds).
>   - Reordering problems such as due to IO priority is resolved as well.
> 
> This will need a lot of testing, which we are working on. But your help with
> testing on UFS devices will be appreciated as well.

That sounds very interesting. I can help with reviewing the kernel
patches and also with testing these.

Thanks,

Bart.

