Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510361CD29;
	Tue, 16 Jan 2024 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705429247; cv=none; b=W3Fw3TRM0Z1I+26Ib2Fz1G9199JvjljZ7AdWU5LU5L/vtl/mT/0exznbWmzkhCS1RLXujdxetNatThT30hvaW/YTFqWFZxwMIF25ChhJuTYeLSp78SxYi1pf0L2AOMg/pKuN2DkwxvOSOwx+RA+bvac/SBe251LCCvjnR+LWu70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705429247; c=relaxed/simple;
	bh=gnQjl1tzNbmalSGhlZ9gZHIv621esDTvo0DdhdLJDpQ=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:From:Subject:To:Cc:Content-Language:
	 Content-Type:Content-Transfer-Encoding; b=rE9HTHMu66Minc1cDoEZ5MwcCnslA7CmFyUcL38bhAivPF/W+EFqqCjbJ00L5dOqynBYPxhZfzvWIir+rsT09e+DLJoYC6+6VNZGAvZEEJS+k0wkgfWMldOFQZn9ATSxi3gH49GX2eyDhgFohXsFoTZycZI3U67hFdZ8hf4iZPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d5efddb33dso5903665ad.1;
        Tue, 16 Jan 2024 10:20:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705429246; x=1706034046;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JG/1+n6ePxtoAUG3Qbwl79wTOKMylFKiQ7nh8g8yQ+o=;
        b=g4d+v8UWdJLHqZnSIDxRjzRS18hIpNrkLPqNLMJ/u0tTv1VCMhokbj/XhMrK6ihKjI
         c3Is+rQdeVk+6DcFQKWDE7HSnkL+GuJ2tp5m7b+seOC8FPEQC0rr+U+XAGesMCGOwatj
         4xp7Je+byUb1tXSLgkRJdlSc6oBM8lfjFHl8SlVMVzkknurh7hPkbNBpo4FYnSvW+gm8
         0Yzc/hc+x0yo07OBJqDAvmw68nK3mxpHnfXXtqtq3rjjP8EHjHZG6i3IWNCxCQoMYBUQ
         T+13lOfXBiLK149c7+0AuEmt9kCGThGc2SaFQ8s4sSpEf8W98VX3sYtYhxBqTnJu5UuV
         UeXA==
X-Gm-Message-State: AOJu0YzTsamWOpr/kGUKrQEEfWQDGKrLpEoh6LfjhHDIOt6l0vX9eTTz
	Ee5l0+pPm1ntZjAVgaXysJLKnZUxn1s=
X-Google-Smtp-Source: AGHT+IHa9RorkOCy9n2FWNQ0utsG7HkkU8lYyXw/kw7/8PDkGXCpSISp/8dJ90ju8gPOMDgMz4bsVg==
X-Received: by 2002:a17:902:db02:b0:1d4:3d94:e183 with SMTP id m2-20020a170902db0200b001d43d94e183mr5568341plx.45.1705429245592;
        Tue, 16 Jan 2024 10:20:45 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:bf53:62d5:82c4:7343? ([2620:0:1000:8411:bf53:62d5:82c4:7343])
        by smtp.gmail.com with ESMTPSA id ix4-20020a170902f80400b001d6ea47ce68sm80059plb.52.2024.01.16.10.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jan 2024 10:20:45 -0800 (PST)
Message-ID: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
Date: Tue, 16 Jan 2024 10:20:44 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bvanassche@acm.org>
Subject: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Christoph Hellwig <hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The advantages of zoned storage are well known [1]:
* Higher sequential read and random read performance.
* Lower write amplification.
* Lower tail latency.
* Higher usable capacity because of less overprovisioning.

For many SSDs the L2P (logical to physical translation) table does not
fit entirely in the memory of the storage device. Zoned storage reduces
the size of the L2P table significantly and hence makes it much more
likely that the L2P table fits in the memory of the storage device. If
zoned storage eliminates L2P table paging, random read performance is
improved significantly.

A zoned storage SSD does not have to perform garbage collection. Hence,
write amplification and tail latency are reduced.

Zoned storage gives file systems control over how files are laid out on
the storage device. With zoned storage it is possible to allocate a
contiguous range of storage on the storage medium for a file. This
improves sequential read performance.

Log-structured file systems are a good match for zoned storage. Such
filesystems typically submit large bios to the block layer and have
multiple bios outstanding concurrently. The block layer splits bios if
their size exceeds the max_sectors limit (512 KiB for UFS; 128 KiB for a
popular NVMe controller). This increases the number of concurrently
outstanding bios further.

While the NVMe standard supports two different commands for writing to
zoned storage (Write and Zone Append), the SCSI standard only supports a
single command for writing to zoned storage (WRITE). A write append
emulation for SCSI exists in drivers/scsi/sd_zbc.c.

File system implementers have to decide whether to use Write or Zone
Append. While the Zone Append command tolerates reordering, with this
command the filesystem cannot control the order in which the data is
written on the medium without restricting the queue depth to one.
Additionally, the latency of write operations is lower compared to zone
append operations. From [2], a paper with performance results for one
ZNS SSD model: "we observe that the latency of write operations is lower
than that of append operations, even if the request size is the same".

The mq-deadline I/O scheduler serializes zoned writes even if these got
reordered by the block layer. However, the mq-deadline I/O scheduler,
just like any other single-queue I/O scheduler, is a performance
bottleneck for SSDs that support more than 200 K IOPS. Current NVMe and
UFS 4.0 block devices support more than 200 K IOPS.

Supporting more than 200 K IOPS and giving the filesystem control over
the data layout is only possible by supporting multiple outstanding
writes and by preserving the order of these writes. Hence the proposal
to discuss this topic during the 2024 edition of LSF/MM/BPF summit.
Potential approaches to preserve the order of zoned writes are as follows:
* Track (e.g. in a hash table) for which zones there are pending zoned
   writes and submit all zoned writes per zone to the same hardware
   queue.
* For SCSI, if a SCSI device responds with a unit attention to a zoned
   write, activate the error handler if the block device reports an
   unaligned write error and sort by LBA and resubmit the zoned writes
   from inside the error handler.

In other words, this proposal is about supporting both the Write and
Zone Append commands as first class operations and to let filesystem
implementers decide which command(s) to use.

[1] Stavrinos, Theano, Daniel S. Berger, Ethan Katz-Bassett, and Wyatt
Lloyd. "Don't be a blockhead: zoned namespaces make work on conventional
SSDs obsolete." In Proceedings of the Workshop on Hot Topics in
Operating Systems, pp. 144-151. 2021.

[2] K. Doekemeijer, N. Tehrany, B. Chandrasekaran, M. Bjørling and A.
Trivedi, "Performance Characterization of NVMe Flash Devices with Zoned
Namespaces (ZNS)," 2023 IEEE International Conference on Cluster
Computing (CLUSTER), Santa Fe, NM, USA, 2023, pp. 118-131, doi:
10.1109/CLUSTER52292.2023.00018.
(https://ieeexplore.ieee.org/abstract/document/10319951).
