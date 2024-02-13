Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A64605B1;
	Tue, 13 Feb 2024 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707848084; cv=none; b=kMd7fy+XecJiBC1rDNLtdcU9vWXmkoHS4ocHKSsJ+jynXEGndS8+IBMT2VLixiLaEEi4AEIAOM0bqBwOwgdrPAv7wQ6FTFkEKWukB+TMh2xrj+vkrqaDoOhtzX2QMElwEUqMnd9Jh4N+WYavJRm45os80Rr5qz0+UdniSViKUos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707848084; c=relaxed/simple;
	bh=4SMcBbGsPnv1zOGgrKHp8RqOfkhcMzhFElcnJBVqWiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvk2PCc763QUVqYJaDKwJhTLkrQOkgS0YSDkWk7sXfwG89YVhGHdp+9kch75exVa0u2tvi7CxwFko0Pmfy1rD1z/cTC90cd9OeVi4dHQjyEzXxpoMeLm2wT/gcwmqg0RaQ2nQadLKzdFCdi5M6ZUpc4Ls+soyGrvcW2D1hOU6P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ctYNuoll; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctYNuoll"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a3c1a6c10bbso397966766b.3;
        Tue, 13 Feb 2024 10:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707848081; x=1708452881; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L2lqGH+hm3YPBGlos9rSeVHI/185s7nCBgo3G4i+7FY=;
        b=ctYNuoll+J17o3H3LPQEMwRSolh9MFQtKBbE9RCVkAnM+g2+b74HrQYIg5gktUlsE9
         YLcBIF/j6FCJpSs8WA1teFCy/kY1xl4iKF+/cIbBpVGy31+bo+KFih2XglEnP6IA58go
         WX5BbJcCrO6qTlIF47U2kLb+G3eRQs/hL4yG3UDVWqkhWykb+t7OITsR60bfNITMUSrB
         oZWWX3eRNIx3fLB+ZG2lL0sHpkdA0itwEPbi6bzPr4TsUcma5ujyw3+ioOWvehQgGhaI
         sEEW2M+6cweYr7igNmc7CF36uPcSriisymQrF2bf/dM10vVk9Ky9IOzyButR+V6AJisZ
         Y9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707848081; x=1708452881;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2lqGH+hm3YPBGlos9rSeVHI/185s7nCBgo3G4i+7FY=;
        b=AFptKvILFrYLo4qmaIa3tg6SHiNrQx+OvjqPQvllU7nDa1A0IBou6BEVCMTmdOnaMH
         SlFN9Zff33ZBkYGhGABPjgh3jkbVi2ViHJBDgixa/VnUd2WLTK0Magc4qDS0xLFHh7v4
         q7P7v6qiX0oMRrz2VrwpUCbFqm+UscdFuy71tMLK28O38YjbXx79W1qEltqhqIolT/5u
         0WcSj6Gffi58gN4yw84Ysom2pr5S5L3GByE4uOb50jQVItV/wyDAjTtw3t6Nwie8rjKK
         02KLDsVTSQvu/N07+IAjtrA6UFacMBENWFtFHtsyjhgwT3hlgWrxBRR+li/JAelaFNx8
         LiDw==
X-Forwarded-Encrypted: i=1; AJvYcCXNFDn/60f/IKG9EtMsNHTwR7lbI7oW4BJ7gghsiRhwUF/XLZWEfHBGp778LgVRQj3qR63U9D3kVppSOtdXJPKFE/fdYh9bCgdq
X-Gm-Message-State: AOJu0Yw8rpQjzG2tBSMs1CFm3G5tBbuFukstA4xokHtoDXZdYHM+Vzzr
	AOI64tTiEcKMNa8YncJAWy3Az+0VnjJLUNfBEz+9ncWhAwYEiQYeVYDwx9YK5SUPNg==
X-Google-Smtp-Source: AGHT+IFXyIj8aGUOng1bDasRN2yKR6YNqgs/O05A5/xceoYl1Q0ap032h28l60HouD7E1+KyAH7FXA==
X-Received: by 2002:a17:906:194a:b0:a3c:c97e:7d64 with SMTP id b10-20020a170906194a00b00a3cc97e7d64mr112754eje.48.1707848080890;
        Tue, 13 Feb 2024 10:14:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW1FClALPR/4auYH6TmPhr4XR1SOheaHI4waBSyKHtLuM4WFEM4XTneXs+ROO88dhY+YDP61OrqHLvDchbewZf8Rzs+JB2Nc/8N
Received: from ?IPV6:2a02:908:1980:b9c0::9761? ([2a02:908:1980:b9c0::9761])
        by smtp.gmail.com with ESMTPSA id vx1-20020a170907a78100b00a3d00afd63csm872511ejc.109.2024.02.13.10.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 10:14:40 -0800 (PST)
Message-ID: <0a892e80-424f-4047-a885-5efbcc75af53@gmail.com>
Date: Tue, 13 Feb 2024 19:14:39 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] usb-storage: Ignore UAS for LaCie Rugged FW USB3
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
References: <20240209151121.1004985-1-tasos@tasossah.com>
 <b16e72ad-3f2d-46a8-8361-2641088694df@rowland.harvard.edu>
 <2978efa3-e83f-4ef5-907d-8232e4b692a5@tasossah.com>
 <6d4b1f55-09df-47e9-945d-fa38cd36588c@gmail.com>
 <b6dcf71b-f094-4664-8d43-7d8c0173f51f@gmail.com>
 <c21f9649-30be-462a-b9ec-f7c96ead30cf@gmail.com>
 <0cf5ea13-6472-47e1-a32f-b9f332656c6a@gmail.com>
 <yq1bk8kl9th.fsf@ca-mkp.ca.oracle.com>
From: Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <yq1bk8kl9th.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 13.02.24 um 15:28 schrieb Martin K. Petersen:
> 
> Julian,
> 
>> I am cross-posting this to scsi list, maybe someone there would be
>> able to understand what is going on.
> 
> I'm going to copy you on a patch I have in my development tree. I would
> appreciate if you could try that out.
> 
> Thanks!
> 
Hi Martin,

Thanks for responding. I tried your patch but it, unfortunately, did not 
help with the issue I and Tasos were having. Not on its own, and not 
with LaCie:Rugged FW USB3:0x2000 added to /proc/scsi/device_info.
Just to make sure we are talking about the same problem: prior to 
c92a6b5d6335, the drive would be usable pretty much immediately after 
connecting - in the logs this manifests by the following rows appearing:

Feb 13 18:59:42 kernel:  sdb: sdb1 sdb2
Feb 13 18:59:42 kernel: sd 8:0:0:0: [sdb] Attached SCSI disk

After c92a6b5d6335, one or more restarts are required (below is from 
Fedora's 6.7.4 with your patch applied on top):

Feb 13 19:01:41 kernel: sd 8:0:0:0: [sdb] tag#13 uas_eh_abort_handler 0 
uas-tag 1 inflight: IN
Feb 13 19:01:41 kernel: sd 8:0:0:0: [sdb] tag#13 CDB: Inquiry 12 01 b9 
00 ff 00
Feb 13 19:01:41 kernel: scsi host8: uas_eh_device_reset_handler start
Feb 13 19:01:41 napoleon2 kernel: usb 2-3: reset SuperSpeed USB device 
number 3 using xhci_hcd
Feb 13 19:01:41 kernel: scsi host8: uas_eh_device_reset_handler success
Feb 13 19:02:11 kernel: scsi host8: uas_eh_device_reset_handler start
Feb 13 19:02:11 kernel: sd 8:0:0:0: [sdb] tag#16 uas_zap_pending 0 
uas-tag 1 inflight:
Feb 13 19:02:11 kernel: sd 8:0:0:0: [sdb] tag#16 CDB: Inquiry 12 01 b9 
00 ff 00
Feb 13 19:02:11 kernel: usb 2-3: reset SuperSpeed USB device number 3 
using xhci_hcd
Feb 13 19:02:11 kernel: scsi host8: uas_eh_device_reset_handler success
Feb 13 19:02:41 kernel: scsi host8: uas_eh_device_reset_handler start
Feb 13 19:02:41 kernel: sd 8:0:0:0: [sdb] tag#17 uas_zap_pending 0 
uas-tag 1 inflight:
Feb 13 19:02:41 kernel: sd 8:0:0:0: [sdb] tag#17 CDB: Inquiry 12 01 b9 
00 ff 00
Feb 13 19:02:42 kernel: usb 2-3: reset SuperSpeed USB device number 3 
using xhci_hcd
Feb 13 19:02:42 kernel: scsi host8: uas_eh_device_reset_handler success
Feb 13 19:03:12 kernel: scsi host8: uas_eh_device_reset_handler start
Feb 13 19:03:12 kernel: sd 8:0:0:0: [sdb] tag#28 uas_zap_pending 0 
uas-tag 1 inflight:
Feb 13 19:03:12 kernel: sd 8:0:0:0: [sdb] tag#28 CDB: Inquiry 12 01 b9 
00 ff 00
Feb 13 19:03:12 kernel: usb 2-3: reset SuperSpeed USB device number 3 
using xhci_hcd
Feb 13 19:03:12 kernel: scsi host8: uas_eh_device_reset_handler success

Four resets are needed with the current kernel-6.7.4. With early 5.19 
kernels on and after 7fb019c46eee it needed one reset, with c92a6b5d6335 
and with e60ac0b9e445 multiple resets were needed too. As 30 seconds 
need to pass between the resets, it does take a while until the drive 
can be used.
I did not test other commits between c92a6b5d6335 and c92a6b5d6335 as I 
was bisecting and only tested the commits suggested by git.
6.7.4 I tested with bare metal Fedora 39, 5.19 with a Fedora 36 VM.
If this was already clear, please feel free to ignore.
In case it is relevant: my drive (but not Tasos') is patched to use 
US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME.

Best regards,
Julian



