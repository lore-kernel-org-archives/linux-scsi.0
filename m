From: Denys Fedoryschenko <denys@visp.net.lb>
Subject: MPT Fusion SAS 2.6.31 regression, crash on heavy load
Date: Mon, 28 Sep 2009 22:41:17 +0300
Message-ID: <200909282241.17631.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hosting.visp.net.lb ([194.146.153.11]:42033 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZI1Tvy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2009 15:51:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

Filled a bugzilla entry, no answer for 3 days, and at same time it is clear 
regression.
http://bugzilla.kernel.org/show_bug.cgi?id=14242

While on 2.6.30.5 MPT SAS controller worked fine, on 2.6.31 it fails on heavy
operations and start spitting errors to dmesg (they vary). Failsystems also
stopped, and i am unable to reboot box properly (only over sysrq or 
hardreset). 

x86, Sun Fire X4100, 8 GB RAM, PAE kernel enabled, module loaded with default
options

I upgrade BIOS, LSI controller BIOS to latest version, it didn't fix the bug.
I cannot do bisection, because this is loaded server and semi-embedded system.
But i can do tests of patches or reverse specific commits, if you point me to
exact commit.

http://www.nuclearcat.com/files/dmesg.ok from 2.6.30.5 kernel
http://www.nuclearcat.com/files/dmesg.fail from 2.6.31.1 kernel
http://www.nuclearcat.com/files/config.gz config from 2.6.31.1 kernel

Let me know if you need any additional information.

Additionally - i have few other similar units (X4100), but with less amount of 
RAM (4GB),HDD's(2 only), less load (but still enough heavy at some moments) 
working ok.

Please CC me on answers, i am not subscribed at any SCSI/LSI list.
