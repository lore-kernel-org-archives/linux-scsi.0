From: "Qi, Yanling" <Yanling.Qi@lsi.com>
Subject: mptfc parallel device scan and modprobe
Date: Fri, 12 Jan 2007 14:36:35 -0700
Message-ID: <0F08E10B769EAF4EA2C43A573B8CC87F824A83@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48765 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030459AbXALVgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2007 16:36:38 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id l0CLZAG0001926
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2007 13:35:10 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id l0CLabNJ018474
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2007 13:36:37 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Hebsur, Shailendra" <Shailendra.Hebsur@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stout, Christina" <Christina.Stout@lsi.com>

Hi All,

 

I didn't follow the thread and progress of the parallel device scan at
FC LLD driver module loading time in the list. I would like to
understand the expected behavior of the parallel scan and
insmod/modprobe.

 

I have a configuration where I have 4 LSI FC ports. When I insmod the
mptfc driver, the insmod process returned very quickly. After the insmod
is finished, only a few scsi-devices are discovered. The 4
scan-work-queue threads keep running to discover the rest of the
devices.

 

I thought the behavior should be

1.	the module init function kicks off the work-threads to do the
discovery.
2.	the module init waits all the work-thread completing the device
scan
3.	the module init function returns

 

If the module init returns before work-threads complete device scanning,
does it cause problem in high level of the io stack?

 

Thanks,

 

Yanling

 

 

Yanling Qi

Engenio Storage Group - LSI Logic

512-794-3713 (Office)

512-794-3702 (Fax)

yanling.qi@lsi.com

 

