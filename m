From: denys@visp.net.lb
Subject: 2.6.38-rc7 WARNING, megaraid, smartctl
Date: Wed, 09 Mar 2011 21:47:11 +0000
Message-ID: <1167f08af1e2b97b06fab57d5dd195db@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hosting.visp.net.lb ([194.146.153.11]:59928 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1CIV4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2011 16:56:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

 Got warning after running command:
 smartctl -d megaraid,0 /dev/sdb

 [ 1350.883338] ------------[ cut here ]------------
 [ 1350.883578] WARNING: at mm/page_alloc.c:2012 
 __alloc_pages_nodemask+0x15d/0x5cc()
 [ 1350.884016] Hardware name: PowerEdge 2900
 [ 1350.884243] Modules linked in: rtc_cmos rtc_core rtc_lib ext4 jbd2 
 mptspi mptsas scsi_transport_spi scsi_transport_sas mptscsih mptbase 
 xt_owner ipt_REDIRECT xt_dscp iptable_raw iptable_nat nf_nat 
 nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter 8021q garp 
 stp llc loop usb_storage ioatdma dca iTCO_wdt iTCO_vendor_support 
 ata_generic pata_acpi ata_piix libata megaraid_sas bnx2 sr_mod cdrom 
 tulip r8169 sky2 via_velocity via_rhine sis900 ne2k_pci 8390 skge tg3 
 libphy 8139too e1000 e100 usbhid ohci_hcd uhci_hcd ehci_hcd usbcore 
 nls_base [last unloaded: usb_storage]
 [ 1350.886186] Pid: 2136, comm: smartctl Not tainted 
 2.6.38-rc7-build-0057 #27
 [ 1350.886414] Call Trace:
 [ 1350.886629]  [<c0132388>] ? warn_slowpath_common+0x77/0x8c
 [ 1350.886851]  [<c0176cd2>] ? __alloc_pages_nodemask+0x15d/0x5cc
 [ 1350.887100]  [<c0176cd2>] ? __alloc_pages_nodemask+0x15d/0x5cc
 [ 1350.887318]  [<c01323ba>] ? warn_slowpath_null+0x1d/0x1f
 [ 1350.887572]  [<c0176cd2>] ? __alloc_pages_nodemask+0x15d/0x5cc
 [ 1350.887797]  [<c0122fd1>] ? need_resched+0x14/0x1e
 [ 1350.888039]  [<c032acbc>] ? schedule+0x70c/0x71f
 [ 1350.888254]  [<c01823c2>] ? page_address+0x33/0xb4
 [ 1350.888478]  [<c017481a>] ? __pfn_to_section+0xb/0xd
 [ 1350.888715]  [<c0105fe9>] ? dma_generic_alloc_coherent+0x5c/0xfb
 [ 1350.888941]  [<c01073d3>] ? nommu_free_coherent+0x0/0x1d
 [ 1350.889168]  [<c0283f72>] ? dma_alloc_from_coherent+0x1b/0x81
 [ 1350.889395]  [<c0105f8d>] ? dma_generic_alloc_coherent+0x0/0xfb
 [ 1350.889616]  [<f8720687>] ? dma_alloc_coherent+0x84/0x8c 
 [megaraid_sas]
 [ 1350.889846]  [<f87218c5>] ? megasas_mgmt_ioctl+0x21f/0x4fd 
 [megaraid_sas]
 [ 1350.890082]  [<f87216a6>] ? megasas_mgmt_ioctl+0x0/0x4fd 
 [megaraid_sas]
 [ 1350.890300]  [<c01a7d8c>] ? do_vfs_ioctl+0x484/0x4be
 [ 1350.890546]  [<c011c10e>] ? do_page_fault+0x2c1/0x2ef
 [ 1350.890765]  [<c019be7e>] ? do_sys_open+0xd2/0xdc
 [ 1350.890983]  [<c01a7df9>] ? sys_ioctl+0x33/0x4e
 [ 1350.891265]  [<c032bf2d>] ? syscall_call+0x7/0xb
 [ 1350.891486] ---[ end trace 80686703a477504c ]---
 [ 1350.891697] megasas: Failed to alloc kernel SGL buffer for IOCTL

 01:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 
 1078 (rev 04)
 01:00.0 Class 0104: 1000:0060

