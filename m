Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926689;
	b=WzG8tFUT7ARYWJQR5rxmx8a/EVsl/iF2FqfTLyQJvFJI9rdXu9E1dc/H0TSAM+Tj/NAP
	 YB8UkQi/FJuxT0oUQzVzBChc5RTGYYZqnxxxzI2dT0Uo+wJyI2Miv+EfP7T0s1cchz8Sd
	 6m1VN6VB6I/MBsOdk7mc2OeXoSDMC6JP0rV3VNCHbbOLrVOqrRnnuOhqgxDGYgPkQIkhl
	 N8kiq6Iz9iE1HkczVMHu1cO2fxhEu6cGzp9JBz40uKlnoJlG7dM1E+1UoHeFGmfBVhk2H
	 6zvmZRbDwBRgFYHYKOwINtRPEOYzJxSPGIxhGkTXysJrAxYpW3bqRZu6Ik7aWGUAHqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926689;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:X-DetectorID-Processed;
	bh=c0tPnW0n/Psfni30veZt9YzAyBiEuw/jPDUDqjZtQ2Q=;
	b=s9aRkBFtGvpMliJRn7TcMiBFxbE8gUVvxyFGp3/OW+lIVb9Gvx30obpMx8ZrOH7L5Ede
	 fhsplrFtmDRBDcjG2BwzMzejiTdKJHxPujA4MKGctlWVy4oF1QY5Ngqb0VbfwH9udyCtb
	 U9wopCf6ptYkORStKDOdFKoOPlvPf9mb/B+Xh5L8AJqZttZFSy7Y+xBtAhyE4ZE3GbONv
	 gbKAW74AhvbNWw5hjI/BUNVbMUKLQpFRSXqWmetiZfyLnnJKFasTwgBvwVO9QUlc+q6YI
	 BRssDNCD+VX+RFXo00F5qEQ9Faa0XwEJYx48g9cTstIJHc6Ec1y7Uo/p4pgncA/vfiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Uz7gaF09;
	arc=none smtp.remote-ip=209.85.161.100
Received: from mail-oo1-f100.google.com (mail-oo1-f100.google.com [209.85.161.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DED606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03DED606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Uz7gaF09
Received: by mail-oo1-f100.google.com with SMTP id 006d021491bc7-706113e92f9so103508eaf.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926688; x=1794531488;
        h=message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c0tPnW0n/Psfni30veZt9YzAyBiEuw/jPDUDqjZtQ2Q=;
        b=u+iBQ79K7oQanl4F2muCDltYGbM5OpKu05aNexhhfJ1l79PfppjLFnOQbb+mednWZg
         pt+rnVa4Ys5Qb+GcqZWZlb+v+gHRmh3ukse1TXJmkR/Ce4kVRLMt8sqTNc5dEE9jWmoE
         PR2ogyVJyCyr53HYuiMQWqVq0VZwPuZKQU+9PJUFqm0DzHmoCKR+ul7wZYPeve7Hno3F
         IxRYS3g147LtiUffU4WBBfVrTNR/Dk/VUDr400x8Ra3pSVCLWNKse+kHPgSuOeFR7dus
         fXCWYmu1nZA4YIVzA+DquCXo2WJXlxHp2fPhfBdJkdMnYQGabkP1WQL/UyluVaPW0i6h
         LrbA==
X-Gm-Message-State: APuU4Z+xOB8OMJbYz/+oS4XZsIwqnmUpnCw3xegrDbGJnZGLHuUiAjfs
	LmLY9ADmooJF7i2f+UMb8Tl5IgsC1/HvSk6xE/7H+fdF2bmMLUEsTcz0J+4GZA6Vm615hwkjJyo
	AhJqOb+XACpaFljc8OEaAMeyNuTpX3y+lycNMdlDRK0S0UrdUARYSo9hhVjjvdaF3giAAOKumAA
	/L1DAzEc7cCxyxrKcHHn4qULe0n9CTkXaSMwbGDO1iBzwaEkF73sVW3uyRrMEfm+iSZnjKox656
	Cwwr4PdhthiGjnvOqUSyKzGJL/2k2PFUEA=
X-Gm-Gg: AYBFou1zBVGsJAkv0ecTqU75wFUVQYsQVHHCktcUt38DyMwZ/1IH8hATJQK3C//VjNu
	CxMzsE+RI/t/swFDd6oSd6Ru5k4M92FsFqh3JBlgexxOKs+GOd6Aw6meJnnWK+mwXMGuYsBB+o4
	UHo1WM6Yc648J5JiX5at/51Co9ty4Hi0eocf9NaSn23khTcQ9QUEGx6+/j2uOrFhhMoMKGYTGyr
	Li3XkxmifbETlPVKDRpVMV4CVl+RFYCBECg4GxIoT7VXeDemshv/MuPj/LhlIbMNC/AtbxgT5YL
	Ez158xaM5mT0f+7OmdRyB4xMmmPjJvQAjPTDX7znPo1Yjh/r3JJgoWFQ0eAVpVZVGnzvZTu/4pB
	FMUdPCQbcMYVb2SqDVaOwYn+hiXRUFEkcPFUoYvT4GoKd4/tA2SNxmb0F5Up8m9apYlLQ/D+hha
	OiNL2TbF5IPK2jp/n7TmEgOh5EuH2OGL0hwfvwxcuL5NqYfDVx6pQGQA==
X-Received: by 2002:a05:6820:1ca5:b0:716:e9e0:5434 with SMTP id 006d021491bc7-716e9e0585bmr583031eaf.35.1793926687728;
        Thu, 05 Nov 2026 16:58:07 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-4ad973f501bsm19059fac.2.2026.11.05.16.58.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:07 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e94f72fb9fso1284965ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926685; x=1794531485; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c0tPnW0n/Psfni30veZt9YzAyBiEuw/jPDUDqjZtQ2Q=;
        b=Uz7gaF09f7VESe5yMNTi1Rn54lfwcA39qTNbIURCQJFfxD0PZ99y8m5idmLysuNFAT
         dc8GbarvoWUeqmwj3fsaLNdCEez15q6Wyc7QJ30tRxp2CoiJ3iM7j/+LFRP5MjOphfTF
         oVP+pysj5ssiC6YVZkFLN2pedSbvqngq0m2tk=
X-Received: by 2002:a17:902:d586:b0:2ed:18cc:d3ac with SMTP id d9443c01a7336-2ed40aad4cbmr15585685ad.16.1793926684960;
        Thu, 05 Nov 2026 16:58:04 -0800 (PST)
X-Received: by 2002:a17:902:d586:b0:2ed:18cc:d3ac with SMTP id d9443c01a7336-2ed40aad4cbmr15585425ad.16.1793926684376;
        Thu, 05 Nov 2026 16:58:04 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:03 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 00/37] scsi: mpt3sas: Validate firmware/user input and fix error-path bugs
Date: Thu,  5 Nov 2026 16:42:15 -0800
Message-Id: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
data and invalid ioctl/passthrough input, and fixes other locking,
reference-count, memory-leak and use-after-free bugs in the driver.

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

 drivers/scsi/mpt3sas/mpt3sas_base.c         |  91 ++++++++--
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  13 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |  64 +++++--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          | 182 +++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_debugfs.c      |  49 +++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 170 +++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  16 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |   2 +
 8 files changed, 495 insertions(+), 92 deletions(-)

-- 
2.53.0

