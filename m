Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072748;
	b=mN7pKeXJqonF2Zb5OFSecROQn7IGv6D5qF0NLIUkuAjCmUuLYFPHQNocOSaq4XMGmVqP
	 KjrcwZT8LS5E94V9GxADbUTiIOlfCWkGYpmAgQdyA8NRW23mSLDg80c1dIYg5BEoWrtHc
	 6SJiawEKjGrpM4r16LHqD55Ww9oFBrSQ2gXHpcZB46r0Ze9+769POquRl1BkCQNOGrJVr
	 WB8QLhnE9PPRhJtlpS0lzJe8BKExzYDv+8uSJXAYndkC2S8Ui4nK6ZXWME+aSBMko6ax6
	 /msSrZLqXISPVmTceaeiQpKBnbHZLLqADIdL9Umg0SyehWot5SbCczA7KkL9lBcyiLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072748;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=EZsmRjvQDZ9BfcG8s1wlKcgBhUSKEabo+IIdtXehhig=;
	b=U3No0lK7TAsKYu0hsTVOj3XWEFA4oi38uMKNwKGcTMFWrfTbf4Q6ZNkfDoS64I//R37g
	 aypltwv+JI7TFhQ+YpMvG4ExJzU6qBrhaViJdBzK/q6hcpqrC6W3G3feswyPC9SbbZe4X
	 2Ek+7/KyGvYAG8ai9QLVgMxnlyI9Sn0Vgrhr/P4dbe/8cB2W1uRmpSxVFaZozQMQJT598
	 lB9Zg0IA12B5YPMikMamRzE2GsKXL+AwYdtW8UDzlHSgaj4pqWw5OJ27z87q3z6DBbzcw
	 s7Gdiot+9p79ZxUriRPewimqlgaMNqAILre3qAj5HbQU6t7Fd9ZR/VTWbzfSN8lBtzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=T4AD8EW6;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9957D606A335
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9957D606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=T4AD8EW6
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so1253699a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072747; x=1795677547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EZsmRjvQDZ9BfcG8s1wlKcgBhUSKEabo+IIdtXehhig=;
        b=NMdFe9Mqs7R6H6I94OzR53XayckXTqRxR+fMM6osqp1uFPTGHv7jjj2F1woKcAE9LS
         QKFJEd7ELSdpvW38O1M5mhACLLO98XiUYHovXXDVLU0TAgwJU9rndjpDGSZnhMB9U7EC
         aW5J3OvsB4z2U1H0D7ZzQeLw/PDxJIlxWhOZu/CK6OjCTlT0OeB4l8SXn1hVF/DuIijb
         /oVXaCnJy0pTvEQHEImHI3xOShUsK8hWhLyHpREgooVfpAaxbZoPbuhu8Yfs4UUbM0cR
         ZhYGlygTvs0X3LcGPggi4qt64V3/eFaJKjnHqUq4FNZhQZeOyGyiPrEjOp4hBPXWbKpe
         l0iA==
X-Gm-Message-State: APuU4Z928yu+GnGJobF1ehHVTP4FNL3IOsn3vXTsppsXUuEty2Uw/CGU
	pLUhdkHt1F00b12XINIsv2MUB+RXScC4C0n4trlUv7dAbA3qG1NVp9VkbmVvK6NH1XM3dQ6w5g4
	isU4q2DwXKQn6ZogL/E3QyVXOLQjtmyQE2BM5nQc21fhtT9+1sb1g/zGIjGEDEJMl5gn16/sm1+
	Y3bsllprS/xaKQxIwDE2q4usuNek2CdAnLDail0D0rMYLN+ASRl+po2jah4TqSmTGz9/ZFkuHxM
	syL24XKcF8rlGH5
X-Gm-Gg: AZFdTZernwAmkA4i74beHGPkqdu/xs6FsvSTT3Xo6USTRg2LMzcy5PH6FkuqPjU+GTz
	pmreBPpdtzqfNR0RxpUmF1X0vyXjHA1jQWQV/SkCVvmxVKDvHorZzpGXd8axo2olG77JqjSOIqe
	DTgHpYck3SXp69QHWvJafyPjD2Wl96STEg1lwQZg56VaYivsb/eNKwr3b/Va4ONVMOwwCUkwkLX
	SMukVhFZjH6Nks6eSlw+CQdXeq4HvoZu2SqfRVG+q8SbItQx8jzLqd/senL19Z+2Q9nWFYsEZhb
	CBtGgg/rroQFxO2qL0+XVSsQknu4nX85LMEzASZO2k77KHiapm6RJsTNJ+l0TgxhJ20mBQR5R10
	Mt4eBP87BD0BbXtrk0vzitcE5iD/Edf3pRgZozoSEPivtSW+jfG66/sSYol01Q9YwT9PoTZdgtP
	WPzvV0MClc8DmF9dkz7xvzUH1dzu73FuG0ZSA=
X-Received: by 2002:a17:90b:4c8f:b0:3ad:6090:a17b with SMTP id 98e67ed59e1d1-3b3d07a208dmr4253298a91.17.1795072746742;
        Wed, 18 Nov 2026 23:19:06 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b405cece29sm513259a91.6.2026.11.18.23.19.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:06 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b3a9826f6dso1644370a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072745; x=1795677545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EZsmRjvQDZ9BfcG8s1wlKcgBhUSKEabo+IIdtXehhig=;
        b=T4AD8EW67Z8mPZzabwSbQQJpxSZH8xKWs544yzT+hXtG5inWTVSZRD8pmhaChxKfh9
         IuhpPjzHGvugYa2bOv6OO60xMtwVaZJ64o2FZUzgGe0XZLhP+AaVO6d/OnJABTcZR1zn
         kd9RASMLHj0zco9AaxQWMQZny8Gkzkfe6t2Ss=
X-Received: by 2002:a17:90b:3943:b0:3a8:f70f:2437 with SMTP id 98e67ed59e1d1-3b3d07e0a06mr4406380a91.50.1795072744769;
        Wed, 18 Nov 2026 23:19:04 -0800 (PST)
X-Received: by 2002:a17:90b:3943:b0:3a8:f70f:2437 with SMTP id 98e67ed59e1d1-3b3d07e0a06mr4406348a91.50.1795072744003;
        Wed, 18 Nov 2026 23:19:04 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:03 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 00/20] scsi: mpi3mr: Fix issues reported by Sashiko
Date: Thu, 19 Nov 2026 12:41:12 +0530
Message-ID: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Fixes for issues in the mpi3mr driver reported by Sashiko.

Changes since v1:
- Patch 14: Fixed the block_io count left raised when the last LUN is
  removed during the command, and the use after free of the SCSI target.
  Both were reported by Sashiko on v1.
- Patch 15: Reworked on top of patch 14 and documented the new member,
  as reported by Sashiko on v1.
- Patch 16: Documented the new lock, as reported by Sashiko on v1.
- Dropped patch 17 ("scsi: mpi3mr: Reject a too small reply size when
  enabling log data"). It is not needed because
  commit e550f2b2b4aa ("scsi: mpi3mr: Validate reply frame size bounds")
  already rejects a reply frame smaller than 64 bytes.

Ranjan Kumar (20):
  scsi: mpi3mr: Fix out-of-bounds read of the BSG request
  scsi: mpi3mr: Fix integer wrap in BSG buffer entry lengths
  scsi: mpi3mr: Remove redundant BSG buffer length checks
  scsi: mpi3mr: Fix PRP list leak in BSG passthrough
  scsi: mpi3mr: Fix reposting of invalid reply address on the admin
    queue
  scsi: mpi3mr: Fix endianness of device handles in BSG requests
  scsi: mpi3mr: Fix integer overflow in the HDB upload bounds check
  scsi: mpi3mr: Fix integer overflow in the log data size calculation
  scsi: mpi3mr: Queue DEVICE_INFO_CHANGED events to the bottom half
    again
  scsi: mpi3mr: Fix target device reference leaks
  scsi: mpi3mr: Fix the 32 bit shift when building the phy mask
  scsi: mpi3mr: Fix empty device list race in the all targets query
  scsi: mpi3mr: Fix the lowest phy number for phys 32 and above
  scsi: mpi3mr: Fix target private data use after free in BSG
    passthrough
  scsi: mpi3mr: Fix block_io accounting when a target is re-created
    during BSG
  scsi: mpi3mr: Fix sense buffer use after free on BSG command
    completion
  scsi: mpi3mr: Fix partly written and lost entries in the log data
    buffer
  scsi: mpi3mr: Fix byte order handling in the NVMe passthrough commands
  scsi: mpi3mr: Fix byte order of the BSG status reply
  scsi: mpi3mr: Use the correct conversion for the diag buffer post
    request

 drivers/scsi/mpi3mr/mpi3mr.h           |  12 ++
 drivers/scsi/mpi3mr/mpi3mr_app.c       | 246 +++++++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_fw.c        |  20 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  82 ++++++++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  34 ++--
 5 files changed, 302 insertions(+), 92 deletions(-)

-- 
2.47.3

