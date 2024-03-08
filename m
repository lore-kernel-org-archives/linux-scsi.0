Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A121DDF1;
	Fri,  8 Mar 2024 15:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709911466; cv=none; b=uwJNaW92cIitR80lnFtY75RLQtiHalqT/CNrw5nR3eOymnRj+bk4ojGJ6ppE3jaTdDzycdmcOegYIxOi9cWAxmF16Hg9v9oYPX4ATwZB6eFoH5pi1M1ajY4oLOtV8FZrAvroBXM5YDEJsd5p0se5gdetZzCt0ykZTT6iVGMA+90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709911466; c=relaxed/simple;
	bh=qFKzJQzmweLwWA7fQaiLcGmedPHl4/cpbx5pbOOlaZ4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=f1yXsRlBl2cCIY0f8IdBqueaiBpkAaAGYkWntXBoklUpPRMip10tR3KVR6FHq372dRFrgmnJjc7pZxFc1G09ceWYcv3JKIkAYZ/R5ByWsCiV/BDILupA+vYtmf0FqHVy+Z3psiwcFyBayOfW4OeWsopf235m6ik63wEA7OkyJ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V22uvG1A; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V22uvG1A"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-412fc5f5152so16123505e9.0;
        Fri, 08 Mar 2024 07:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709911463; x=1710516263; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8C7xWhkY0C7RLzItTMBqFkP7D6FH2fcAy9oM/cqZ5a8=;
        b=V22uvG1AS5GTs7Dv9qYzyEeMmoLPTe/7pLWS0cY84H5XDvyAr8p6NZkp/a7kqhd8Xo
         sL2JseWF+IdftQE3yWUcXLTofNV4X0FrLg15VHptuajH+sZZ2B5GGFNhXNfRMUDFSDF7
         7VlaC9pd+WH1Z2YL5I8AKPrwmMmOE8N/eGTZLuHditcUrp8gB4Y4PIcAXx8ga9ak8sMe
         jclyT+HIX/dMZgEsl/lYX83HhpILQBEtMzR2cwC80B49Rlodr5pj+04FyLB/yUwUsQlV
         ms/ebPGY+x3rSI+d+FUF42fQiuLoqNEpFyt1bBwtCej9FGBlOaWNPCAy0lV86HhWOOxV
         3fVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709911463; x=1710516263;
        h=content-transfer-encoding:subject:from:to:content-language
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8C7xWhkY0C7RLzItTMBqFkP7D6FH2fcAy9oM/cqZ5a8=;
        b=pG9wV2P7Nz7WwrLPyijLFHqCEICetaZ7/KJNggcv8aPNRyldaK9cMetPztRi0A0kMC
         F+/rQ2OQwzriF3alzCoG4apni+2+r0LTsBTg9rrqZYQTF8SdZ/0jKGJQYBbWapMB862D
         LBjmXjBSmeewWBw9jUug9U8roPhUCVa5V0M4ElMGMJ+KTMfuCY4ZMxZ2+4na4aGxfb5u
         UE6MTvigE6EdZrbktjY016QpndoIPGemR8ydZojnIMwDv/sPspm9vbChXHN+GIDXsyH0
         jXDbmeSAnoRrS3gJSPSB79hFqTqrPEt4xsX9w0N0KSECBeBDGx1bw4S/90UsZYlS4YsY
         9s3g==
X-Forwarded-Encrypted: i=1; AJvYcCUvIvA6fh8UwFU0ctWjtZapMM9+sWzoZXja58eQ3zn7tSkKdLt9QeLMurqn35oSFewiKeazpwkGZGOKEewQVdsadYj2jKqzkSFjSun1nJMN+gfP1QMrgU5511EwC5xFmejEBLqixzzo
X-Gm-Message-State: AOJu0Yy/zvI0wQYjwdqYipQd2TiXPkvoZZbk16qBTVWPle1fJSzxLkSW
	nNrCH3P89BwR/Rq05r0pw02iSmyBPmOzRZNwWqtr9E9639+WvAc=
X-Google-Smtp-Source: AGHT+IHUI6loaI/duFWcELxuIpCbPqqgE3P6KXwhlFCIjHlCmHCTLap9q9e+uNxXjS9j0Ga7XMLRow==
X-Received: by 2002:adf:f043:0:b0:33e:7aeb:fd8 with SMTP id t3-20020adff043000000b0033e7aeb0fd8mr430864wro.32.1709911462815;
        Fri, 08 Mar 2024 07:24:22 -0800 (PST)
Received: from localhost (234.red-88-29-107.staticip.rima-tde.net. [88.29.107.234])
        by smtp.gmail.com with ESMTPSA id by1-20020a056000098100b0033e22341942sm20663213wrb.78.2024.03.08.07.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Mar 2024 07:24:22 -0800 (PST)
Message-ID: <cc8d00fa-9ffb-441e-9483-7ef4a581e9d2@gmail.com>
Date: Fri, 8 Mar 2024 16:24:20 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
 BLOCK ML <linux-block@vger.kernel.org>, SCSI ML <linux-scsi@vger.kernel.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: WARNING: CPU: 45 PID: 84967 at ../block/mq-deadline.c:659
 dd_exit_sched+0xce/0xe0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This warning arose in the middle of a lpfc bug.
The block/mq-deadline.c file of this SUSE kernel is synchronized with
the latest version, and perhaps the bug is relevant for upstream.

Thank you.

  ------------[ cut here ]------------
  statistics for priority 1: i 219 m 0 d 219 c 218
  WARNING: CPU: 45 PID: 84967 at ../block/mq-deadline.c:659 dd_exit_sched+0xce/0xe0
  Modules linked in: hid_generic usbhid st sr_mod cdrom lp parport_pc ppdev parport xfrm_user xfrm_algo xsk_diag tcp_diag udp_diag raw_diag inet_diag unix_diag af_packet_diag netlink_diag joydev 
binfmt_misc af_packet 8021q garp mrp stp llc bonding tls iscsi_ibft iscsi_boot_sysfs rfkill intel_rapl_msr intel_rapl_common ipmi_ssif nls_iso8859_1 nls_cp437 vfat fat intel_uncore_frequency 
intel_uncore_frequency_common nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp mgag200 i2c_algo_bit drm_shmem_helper coretemp acpi_ipmi pmt_telemetry bnxt_en kvm_intel drm_kms_helper ipmi_si 
mei_me pmt_crashlog pmt_class intel_sdsi syscopyarea sysfillrect kvm isst_if_mmio idxd isst_if_mbox_pci ipmi_devintf sysimgblt irqbypass pcspkr isst_if_common fb_sys_fops hpilo mei idxd_bus intel_vsec 
ipmi_msghandler button fuse drm ip_tables x_tables ext4 crc16 mbcache jbd2 dm_service_time sd_mod lpfc nvmet_fc crc32_pclmul crc32c_intel nvmet configfs ghash_clmulni_intel nvme_fc nvme nvme_fabrics 
xhci_pci xhci_pci_renesas xhci_hcd nvme_core aesni_intel ehci_pci ehci_hcd nvme_common t10_pi crypto_simd crc64_rocksoft_generic cryptd usbcore scsi_transport_fc crc64_rocksoft hpwdt crc64 wmi 
dm_mirror dm_region_hash dm_log sg scsi_dh_rdac scsi_dh_emc dm_multipath scsi_dh_alua dm_mod scsi_mod efivarfs [last unloaded: parport_pc]
  Supported: Yes
  CPU: 45 PID: 84967 Comm: kworker/45:1 Not tainted 5.14.21-150500.55.49-default #1 SLE15-SP5 a8d284bf25556592b1cf60fe7a08b3519f64459a
  Hardware name: HPE ProLiant DL360 Gen11/ProLiant DL360 Gen11, BIOS 2.12 12/13/2023
  Workqueue: fc_wq_0 fc_starget_delete [scsi_transport_fc]
  RIP: 0010:dd_exit_sched+0xce/0xe0
  Code: f5 5e 01 00 75 cf 44 8b 4b 3c 8b 4b 34 44 89 fe 8b 53 30 44 8b 43 38 48 c7 c7 c0 78 be 89 c6 05 be f5 5e 01 01 e8 52 d6 b8 ff <0f> 0b eb a7 0f 0b e9 7b ff ff ff 0f 1f 80 00 00 00 00 0f 1f 44 00
  RSP: 0018:ff1a4b078525fca8 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ff179d58de4b8280 RCX: 0000000000000027
  RDX: 0000000000000000 RSI: 00000000fffdffff RDI: ff179e563f562988
  RBP: ff179d58de4b8348 R08: 0000000000000000 R09: 0000000000000001
  R10: 0000000000000000 R11: ff1a4b078525fac0 R12: 00000000000000da
  R13: 00000000000000db R14: ff179d58de4b8200 R15: 0000000000000001
  FS:  0000000000000000(0000) GS:ff179e563f540000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000055b308a6a2f0 CR3: 0000000112ad4003 CR4: 0000000000771ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   <TASK>
   blk_mq_exit_sched+0xf4/0x140
   elevator_exit+0x34/0x50
   del_gendisk+0x1df/0x260
   sd_remove+0x2b/0x50 [sd_mod 108a8db1998ebfa85269b3443a86c030efc2748a]
   device_release_driver_internal+0x201/0x220
   bus_remove_device+0xd8/0x150
   device_del+0x18d/0x3f0
   ? attribute_container_device_trigger+0x7d/0xe0
   __scsi_remove_device+0x102/0x140 [scsi_mod 08708485d882770c298abf1048a3cad58978296b]
   scsi_remove_device+0x21/0x30 [scsi_mod 08708485d882770c298abf1048a3cad58978296b]
   scsi_remove_target+0x18b/0x220 [scsi_mod 08708485d882770c298abf1048a3cad58978296b]
   process_one_work+0x264/0x440
   worker_thread+0x2d/0x3c0
   ? process_one_work+0x440/0x440
   kthread+0x154/0x180
   ? set_kthread_struct+0x50/0x50
   ret_from_fork+0x1f/0x30
   </TASK>
  ---[ end trace b16f99388190585f ]---
