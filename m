From: Sebastian Frei <Sebastian@schnapsleichen.de>
Subject: dc395x.c: Please, contact ... to help improve support ...
Date: Wed, 8 Mar 2006 13:36:37 +0100
Message-ID: <200603081336.37840.Sebastian@schnapsleichen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natipslore.rzone.de ([81.169.145.179]:902 "EHLO
	natipslore.rzone.de") by vger.kernel.org with ESMTP
	id S1750991AbWCHMgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 07:36:09 -0500
Received: from lapnop.qdt (dslb-084-056-237-108.pools.arcor-ip.net [84.56.237.108])
	(authenticated bits=0)
	by post.webmailer.de (8.13.1/8.13.1) with ESMTP id k28Ca27d002180
	for <linux-scsi@vger.kernel.org>; Wed, 8 Mar 2006 13:36:03 +0100 (MET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

(please CC, I'm not subscribed)

I got during a backup the following messages in the system log:

Mar  8 03:44:08 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 03:44:08 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 03:44:08 PINGUIN drivers/scsi/dc395x.c: Please, contact 
<linux-scsi@vger.kernel.org> to help improve support
for your system.
Mar  8 03:44:08 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 03:44:08 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 03:44:08 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 03:44:08 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 03:46:30 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 03:46:30 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:36:21 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:36:21 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:39:22 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:39:22 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:39:22 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:39:22 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:39:22 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:39:22 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:39:22 PINGUIN dc395x: sg_update_list: sg_to_virt failed
Mar  8 04:39:22 PINGUIN dc395x: sg_update_list: sg_to_virt failed

It is an opteron, 1GB RAM, a Tekram DC-315U controller with a HP DDS4 tape 
drive, connected with a narrow->wide SCSI adaptor.

Some info:

Linux PINGUIN 2.6.15.6 #15 Mon Mar 6 11:30:52 CET 2006 x86_64 x86_64 x86_64 
GNU/Linux

Mar  7 19:31:01 PINGUIN dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC 
TRM-S1040 v2.05, 2004/03/08
Mar  7 19:31:01 PINGUIN GSI 19 sharing vector 0xC1 and IRQ 19
Mar  7 19:31:01 PINGUIN ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 19 (level, 
low) -> IRQ 19
Mar  7 19:31:01 PINGUIN dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), 
dev_mode=0x57
Mar  7 19:31:01 PINGUIN dc395x:                AdaptMode=0x0f, Tags=4(16), 
DelayReset=1s
Mar  7 19:31:01 PINGUIN dc395x: Connectors: int50  Termination: Auto Low High
Mar  7 19:31:01 PINGUIN dc395x: Performing initial SCSI bus reset
Mar  7 19:31:01 PINGUIN scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC 
TRM-S1040 v2.05, 2004/03/08
Mar  7 19:31:01 PINGUIN dc395x: Target 03:  Sync: 48ns Offset 15 (20.8 MB/s)
Mar  7 19:31:01 PINGUIN Vendor: HP        Model: C5683A            Rev: C111
Mar  7 19:31:01 PINGUIN Type:   Sequential-Access                  ANSI SCSI 
revision: 02
Mar  7 19:31:01 PINGUIN st: Version 20050830, fixed bufsize 1048576, s/g segs 
256
Mar  7 19:31:01 PINGUIN st 0:0:3:0: Attached scsi tape st0<4>st0: try direct 
i/o: yes (alignment 512 B), max page re
achable by HBA 1048575

Some things I should do ?

S.
