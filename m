Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996718;
	b=oooYuhDDZw7sPMR1cbRl++XpOaH9xVTWcFXd5i+CK2rGPY6lqF6M66MGnstHLLzc6hmg
	 7wwZ77WMXF8d3kZEJuZf/NKYOug4yWr9WDpIZODQ/RZ+J9R/kZeQMrNHPhtuRdS6bj6Wt
	 xgwdj6hXU3xMj+RaeBcKMpqKnMkJiRAROPTknZhoNU+zszCk3maLEbz1aBaPllvtBdMxm
	 I31ljxoe3XPJQmWeBbeeymXte/iJQrNwOZRwH9zDGl1SWFrTnr6sXipV89KK1+vljEj4k
	 /sZNgmPn6+i/fXlB2wvvIn5qV43yJxlOYy7HOoMnUAkB+p2JLgcmY0FXBcVG2Icyrgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996718;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:X-DetectorID-Processed;
	bh=XO7v7OVdCSqVz5PA7ENCh4Zfu0jsmXhkcKdQH//0PA4=;
	b=v1iC8f6qcETBD6OjRLFcLdvBOxoobRcIcHznUT5qnl4QMzcatETTI+n+Kj+Ld/9u7Vzs
	 3ALhxxhrjG8hwaen6CJMyW1q2ECni3EsI2HiOkXnja4eTk8BMbahxjEicAie3+NVjCszp
	 Eb/t2NCtTdSdyqepenH+x+FQldexDCcWAb0MpsGzV+NcGKolOchC4tQ0cyBf3MwEj8/Ji
	 F30K96gKO1vj6WN6dIqDBHiVIGsBBVLTnF08dyjS5qHyxy5quqMmC79ppf2WEMj4xZ7jn
	 VHl/dL6PDJSKtwyiLSYXKiIP+mWsubo7Hei6h1GPjSOxbQXfwS+T0CTdntMfoutpJoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EC6nl6OU;
	arc=none smtp.remote-ip=209.85.210.228
Received: from mail-pf1-f228.google.com (mail-pf1-f228.google.com [209.85.210.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DDB606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:11:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70DDB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EC6nl6OU
Received: by mail-pf1-f228.google.com with SMTP id d2e1a72fcca58-8a070755c8cso463848b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:11:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996717; x=1795601517;
        h=message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XO7v7OVdCSqVz5PA7ENCh4Zfu0jsmXhkcKdQH//0PA4=;
        b=dDP+FruRnWcnueuJ/HZhe/m15xRVqw/kCW0jhdkw8TttaPDCtyJGT0/SMBr7xzGvQj
         cfpDO+6KO65ClHKS9ntojvdDx3wuh0JAv5n475CTlP4yMnQg+tIdH+A8eEM4CFObLg9x
         dzVWZs34sMe5d/nSXl/U8VnCVsk/nEzHoRQ4GRWRsLIr4nIumIHOehGtKtF+wBKTAmNQ
         RT4WWH5lZaHGr2lntzBd1SqZfNwTLYaUL/s9TTNJ9fwn4963pygpyF62tjT4VghTpnLq
         /iBuO8zanU9HAEFP8CQ8ooOzh6SEZThVY3VS/lUR6HElAU4b5sp9hTYvKUdZCVFVCT9M
         Soyg==
X-Gm-Message-State: APuU4Z/9CxlbFV+sdHTk7gcyzlFVFyhfMgHZ85clA7RANnvPUHmcJncW
	8aV+eQapa7UhdJwrYL4hgGxyLITCTip1jP3Suo1SyMWRlnsLd70NhZNtYjm3QBfyUtu4vfz31rX
	ckFaK0F7grGqsXy5tWwk95SMatkbGocGxzqa2J8D8X4Dto95GCzoOC9jGmMuOLAA1i/ULdLk37r
	PdecyIWvZ+cydPxIkFVUvrBRS9PMn9uIa3qpsVYcWyDdKFJqhlS4Jp2Icj7zC34ZOAItKdjL8d1
	acrHCcSp4LCEtm8aiv3uDb/vrOxZQ7qzCY=
X-Gm-Gg: AZFdTZfXb2JjttBlyVxt23wXf4X0qc9EE1N38d+GuRU3SvqIgdNDLB4OszJCy1o0l7/
	UI/R3SyfsC80houydipnGrScW5r/8bCr+krT31i2b7wPZXiSw/FhjXF15FOD1ff3opnDJi1ItMz
	m1No2TzLiqQuCzISErvFhQ9qe5VT7TEUKkctiaxi7Rh2gHGBU+GmI5f5nObxNkgIvHLOnPBIVE6
	9j7Y3JNuUJ3xB9ZPcFlc9Uct2jhX5RujV4rBADbs+lOWzpTShpg0HDncaLoQJNGOXbE7VcdoOai
	/9Fjun9L+eh/ubYbS+JiKz9hAF+atQRou23+v7JE0QGrqycOe/lCnroex6CZ/rizLcac/T2vwcs
	RwuPPu6Ub7fdN1CNClfLrhbU173pDUjcX9MQh6/SUe5MJa78aEMXYkidP5UXV8dm1W69k424En0
	qdXvMHm21tqWPK7hYvhq6JSjKKoY1M1W5nvxXVO1NcWcpaI54bWNtu3R2p
X-Received: by 2002:a17:90b:448e:b0:3ac:a1c7:20fd with SMTP id 98e67ed59e1d1-3b3d06a142amr2114123a91.4.1794996716741;
        Wed, 18 Nov 2026 02:11:56 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abece214sm3961703a91.3.2026.11.18.02.11.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:11:56 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b17b31c3beso853947a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996715; x=1795601515; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XO7v7OVdCSqVz5PA7ENCh4Zfu0jsmXhkcKdQH//0PA4=;
        b=EC6nl6OUor1H4QaDZN5beGcP8uGOnv4wW24SHISWKJpJflZaMszSDV/pxQj60x8QqI
         Y0UqfxebLfW0n04dUrSAx0lM90t7tErERP3jJMdaj8l4SKAaA3tTPw4AI8pjVeitt1AP
         Zgcve3iDMLWGxxGmTnfJyYqgl+Bs7TdL6NTsE=
X-Received: by 2002:a17:90a:d2d0:b0:3ab:31e6:12fc with SMTP id 98e67ed59e1d1-3b3d051ac2cmr2109716a91.0.1794996714766;
        Wed, 18 Nov 2026 02:11:54 -0800 (PST)
X-Received: by 2002:a17:90a:d2d0:b0:3ab:31e6:12fc with SMTP id 98e67ed59e1d1-3b3d051ac2cmr2109682a91.0.1794996714162;
        Wed, 18 Nov 2026 02:11:54 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.11.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:11:53 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	thenzl@redhat.com,
	mgandhi@redhat.com,
	loberman@redhat.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 00/37] scsi: mpt3sas: Validate firmware/user input and fix error-path bugs
Date: Wed, 18 Nov 2026 01:56:09 -0800
Message-Id: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

This series hardens the mpt3sas driver against malformed firmware
data and invalid ioctl/passthrough input, and fixes a number of
locking, reference-count, memory-leak and use-after-free bugs in
the driver.

Changes in v2:
--------------
- Addressed the issues reported by the Sashiko review and the kernel
  test robot's build warning.

Patch 1:
- Handle U16 wrap and request_sz smaller than request frame plus two
  SGEs.
Patch 2:
- Reject pages larger than U16_MAX; zero the buffer with kzalloc().
Patch 3:
- Add ioc->shost check and also set ioc->shost before the ioc is added
  to mpt3sas_ioc_list.
Patch 4 (host_trace_buffer):
- Dropped the ctl_cmds.mutex locking from
  mpt3sas_process_trigger_data() to avoid the possible deadlock with
  the controller reset path; locking there will be handled in a
  separate patch.
- Reset ring_buffer_sz/offset when the trace buffer is (re)posted.
- Take ctl_cmds.mutex in host_trace_buffer_enable_show().
Patch 7 (SMP length):
- Reject request/response lengths <= 4 (previously < 4), which would
  have produced a zero-length SGE.
Patch 8 (device handles):
- Return 0 instead of -1 from _scsih_add_device() for an out-of-range
  handle.
Patch 9 (topology/IR events):
- Clamp EventDataLength to the max reply frame size;
- Reject events shorter than their header; the per-event entry counts
  are clamped to the remaining data.
Patch 14:
  - Fix -Wformat-truncation warning reported by the kernel test robot.
Patch 16:
- Added ioc->chip checks to _config_request(), make_ioc_ready,
  hard_reset_handler and the IR/NVMe shutdown helpers.
Patch 17:
- Fix signed count check for ValidEntries.
Patch 19:
- Reject hba_queue_depth values that would underflow scsiio_depth.
Patch 20:
- Fix signed overflow and bound page size to 2^12..2^16.
Patch 23:
- Validate against sas_node->num_phys rather than nr_phys_allocated.
Patch 26:
- Increase min reply_sz to sizeof(Mpi2SCSIIOReply_t) and reject
  chain segments with more than U8_MAX SGEs.
Patch 28:
- Check return value of _config_request() and return without issuing
  WRITE_NVRAM request.
Patch 36:
- Do the sg_tablesize * page_size multiplication in 64 bits.
v1: https://lore.kernel.org/linux-scsi/1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com/

Shivasharan S (37):
  scsi: mpt3sas: Validate firmware-reported IOCRequestFrameSize
  scsi: mpt3sas: Validate RAID configuration page length
  scsi: mpt3sas: Pin Scsi_Host while an ioctl is using its ioc
  scsi: mpt3sas: Fix locking and bounds checks on host_trace_buffer
    sysfs files
  scsi: mpt3sas: Fix unlocked use of raid_device in
    enable_sdev_max_qd_store
  scsi: mpt3sas: Fix invalid kfree() of fw_event_work event_data
  scsi: mpt3sas: Validate SMP request/response length in bsg handler
  scsi: mpt3sas: Validate firmware/user supplied device handles against
    MaxDevHandle
  scsi: mpt3sas: Clamp topology/IR event entry counts to EventDataLength
  scsi: mpt3sas: NULL ioc->reply_post after freeing it
  scsi: mpt3sas: Fix port_table memory leak in _scsih_sas_port_refresh
  scsi: mpt3sas: Fix leak and dangling pointer for io_uring_poll_queues
  scsi: mpt3sas: Validate max_data_size in MPT3EVENTREPORT ioctl
  scsi: mpt3sas: Fix buffer overflow in _scsih_scsi_ioc_info
  scsi: mpt3sas: Fix Scsi_Host leak on invalid/tampered device probe
  scsi: mpt3sas: Fix page fault from stale ioc->chip after PCI error
    recovery
  scsi: mpt3sas: Clamp ValidEntries in driver trigger page update
    helpers
  scsi: mpt3sas: Clamp firmware reply copies to the allocated reply
    buffer
  scsi: mpt3sas: Reject implausibly small
    MaxReplyDescriptorPostQueueDepth
  scsi: mpt3sas: Validate CurrentHostPageSize before using it as a shift
    amount
  scsi: mpt3sas: Clamp sense_length before copying into
    transfer_packet->sense
  scsi: mpt3sas: Clamp num_luns in
    _scsih_wait_for_target_to_become_ready
  scsi: mpt3sas: Validate phy_number in mpt3sas_transport_update_links
  scsi: mpt3sas: Require CAP_SYS_RAWIO for mpt2ctl/mpt3ctl ioctls
  scsi: mpt3sas: Fix SGE offset boundary check in _ctl_do_mpt_command
  scsi: mpt3sas: Enforce minimum reply frame size and validate chain
    segment size
  scsi: mpt3sas: Replace panic() with error return in hard_reset_handler
  scsi: mpt3sas: Replace panic() calls with error returns in
    _config_request
  scsi: mpt3sas: Bound event-log copy size against reply frame size
  scsi: mpt3sas: Add _ctl_diag_buffer_reset() helper to clear diag
    buffer state
  scsi: mpt3sas: Restrict ioc_dump debugfs and replace raw ioc dump with
    text
  scsi: mpt3sas: Fix out-of-bounds bit operation in
    _scsih_check_topo_delete_events
  scsi: mpt3sas: Bound SMP passthrough buffer reads to actual buffer
    size
  scsi: mpt3sas: Release sas_device reference on error in
    mpt3sas_transport_port_add
  scsi: mpt3sas: NULL the event_log pointer after freeing it
  scsi: mpt3sas: Bound NVMe passthrough transfer size against PRP buffer
    capacity
  scsi: mpt3sas: Update driver version to 59.100.00.00

 drivers/scsi/mpt3sas/mpt3sas_base.c      | 142 +++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  16 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  95 ++++++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 201 ++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_debugfs.c   |  49 +++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 203 +++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  16 +-
 7 files changed, 608 insertions(+), 114 deletions(-)

-- 
2.53.0

