Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045122906;
	Thu, 18 Jan 2024 00:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705538322; cv=none; b=DEOFTNGI/zffmjCprAZczeDYbwfMJTMsXSiAtPk4PQgzDtgVw/uC6/ZrgPif50/S2Xzbhe/jHfaER52DZssb4r2X0VuL+sZccRM8ImnWXDynm5AEk0Eks8MfIivcXgbbF7tWB5sgUIj+dynmf4Jl/vRtrXmWBuBJcvPDLucoiaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705538322; c=relaxed/simple;
	bh=43cXtXkjNNAjs9RqNFtvUOxZFykRoN/UIFlmIiPzR2g=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=dkABWP0XyOu6QtCWKHC5ZyKNERjKpyVIJYEBNgPlFiBaatUhiyxS+jOf1D5XK8x/vp0hHBqLymJ2BL+tRx54aO4HsWkSDaKeRxLdMFDyDiwYiVfNgvzv8Achhcpis6NBam6icBD0a1ZbksXAhW89B4ZNdXJ1ke68dpXZEMdqLxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3606eb704edso48450685ab.2;
        Wed, 17 Jan 2024 16:38:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705538320; x=1706143120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=43cXtXkjNNAjs9RqNFtvUOxZFykRoN/UIFlmIiPzR2g=;
        b=rv02fhsqZIADgwQkhfuoYIhU2HUgA4uJH5qTQ0dWxymcBYKA5zVi+O+m4Xsiv2UcNL
         Y/jwSPi/2nbPb1fwhL6MepA64pQRkR54fIAvKw7jqvlaaG8iim98AATWkEgQWmpkbgSg
         RJBFHCJVLh75l/9aLf/DGuQTWRnYFtN8e8wn+SQuKinc06zrMLZioVJ7IlbI4NBfzEPO
         Y5ByvnQckUxoQebuQxtkekAkVDjpwojtA9H3h/ZGDa+DdOkKXLBgAk9SZGGDI7PBG+QZ
         Pj43BxFYsqxt4uUJOrQTQQ4KknvmDpbI7KbSYyAIsk1FdQ6cz8amjPuNZN6FKSpkBpc3
         EoYQ==
X-Gm-Message-State: AOJu0YxpOlraJlVrR5tUPUXKPYlUgF2rPVCwIEb4WAYdc9HQV5w1v0wu
	Yb4/DliDNmKpp0x21R8XSE+QndW9f9iYvqUt5+HIBAd8faCILmHsE5jsXSUY
X-Google-Smtp-Source: AGHT+IHUX6Yvw4cRZZSJ8OOKM9yyNwN223wFLjz8VnjEQWLnz1h/XTUrSKYudP6Rr2kmX7YlNlGM0g==
X-Received: by 2002:a92:cc01:0:b0:361:9667:39f0 with SMTP id s1-20020a92cc01000000b00361966739f0mr162412ilp.35.1705538319865;
        Wed, 17 Jan 2024 16:38:39 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id s10-20020a65644a000000b005ceb4a70483sm217397pgv.7.2024.01.17.16.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 16:38:39 -0800 (PST)
Message-ID: <c6dfb4f5-10f9-461e-8743-b730a8384f95@acm.org>
Date: Wed, 17 Jan 2024 16:38:37 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
 <43cc2e4c-1dce-40ab-b4dc-1aadbeb65371@acm.org>
 <c38ab7b2-63aa-4a0c-9fa6-96be304d8df1@kernel.dk>
 <2955b44a-68c0-4d95-8ff1-da38ef99810f@acm.org>
 <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/24 10:43, Jens Axboe wrote:
> Do we care? Maybe not, if we accept that an IO scheduler is just for
> "slower devices". But let's not go around spouting some 200K number as
> if it's gospel, when it depends on so many factors like IO workload,
> system used, etc.
I've never seen more than 200K IOPS in a single-threaded test. Since
your tests report higher IOPS numbers, I assume that you are submitting
I/O from multiple CPU cores at the same time.

Thanks,

Bart.
