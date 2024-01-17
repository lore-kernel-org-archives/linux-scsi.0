Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F3722618;
	Wed, 17 Jan 2024 17:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705513018; cv=none; b=qOCM28KFCTh5v4/zw5WXe0+iqdX47IwbhdFi4PX0tb8l7j8+mmvsHswyGZ8/sgn91T2YO7PkvBb3WyGaUGQ4Lc69o+vxDbb24X0F6ZwHCrPE52To3eGhHgg6ttx7VmAJubQy0rbLU3dHtQ7BXHm/El47ijb00TnTq+1yEE7TTzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705513018; c=relaxed/simple;
	bh=OEzof7qyTLruGa+JN283GHR3pCSjT8MuZ8if8KRkzM8=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=XH8WxzWVhjtw4D0nG+1F5/RAdbrUJ2j5hgcGhspB03GZsiW8dB6wCbhtPAdKqBsGttFHZU41eVhOBNKTfKiPk7uX2kYj6/A+oUJ2uMu4huw4/bgCxKUxAciz3rzEgAwW0bGf6bSvmi6K0HWssWH0xNpGpR11F0KDfYcCl3KzJoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6daa89a6452so6988554b3a.2;
        Wed, 17 Jan 2024 09:36:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705513016; x=1706117816;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HLcu/boAZYyJQLYT+m7wrWheub7FYhYbkhG1JYhS+fk=;
        b=jPnEu9vDMBEos4difq4Q6+9hwt1QMFa/uktFnwJ5cKjhbGc3xQfdlU5W3Va1feHA0n
         usuV1rZZD5fGZJRva2o4uBhVnktZeDkGllqS57h1bZPiCFfBCfJ1vOuZbjrpnHK/QbQH
         zEHVVDwb+1DozyvWgYsKOlqy/SRPrTCNp/O/2sUkWuosl86/V2vKN+THYtOD/rno8siJ
         S9SpPfh5d785gB6fb9jxyH5Tw0gSaQEJWU6o4L+d7XPInr/voZvqAfeqSaG0nzLvP905
         RHXS4nL6M00z8HGqv3WyyZmNrFEA6Jpyksy3OEfyeItlqBVylYQw7AAQoEfKMcVUZ4g+
         /lRg==
X-Gm-Message-State: AOJu0YzFiHSeVMTHxR9kTI6IvNAWR0faI5rdd7HvNzrq/sI0zXs96Qd0
	r1C3CV/qRDWU51sRr1FAq3MubgYK9kI=
X-Google-Smtp-Source: AGHT+IHI9/Ofhg6vM6YAfEYG7xK18CTwCIfRXr/qD5ZaProbRjtw16y9FIupDIFf8JVEce1mLFyazg==
X-Received: by 2002:a05:6a20:439e:b0:19a:9655:49fa with SMTP id i30-20020a056a20439e00b0019a965549famr5691111pzl.84.1705513016241;
        Wed, 17 Jan 2024 09:36:56 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:5421:8f53:45a:4e37? ([2620:0:1000:8411:5421:8f53:45a:4e37])
        by smtp.gmail.com with ESMTPSA id fi21-20020a056a00399500b006d0d90edd2csm1698751pfb.42.2024.01.17.09.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 09:36:54 -0800 (PST)
Message-ID: <43cc2e4c-1dce-40ab-b4dc-1aadbeb65371@acm.org>
Date: Wed, 17 Jan 2024 09:36:52 -0800
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
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/24 15:34, Damien Le Moal wrote:
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

When posting this patch series, please include performance results
(IOPS) for a zoned null_blk device instance. mq-deadline doesn't support
more than 200 K IOPS, which is less than what UFS devices support. I
hope that this performance bottleneck will be solved with the new
approach.

Thank you,

Bart.

