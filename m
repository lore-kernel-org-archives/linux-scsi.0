From: "Sabharwal, Atul" <atul.sabharwal@intel.com>
Subject: Physical disk removal does not create hotplug events
Date: Tue, 23 Mar 2004 10:03:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2F75A5CCEF1E6A4C8CA2E75CF7F529E9022B1547@orsmsx409.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr06.intel.com ([134.134.136.7]:33233 "EHLO
	caduceus.jf.intel.com") by vger.kernel.org with ESMTP
	id S262758AbUCWSDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2004 13:03:35 -0500
Received: from talaria.jf.intel.com (talaria.jf.intel.com [10.7.209.7])
	by caduceus.jf.intel.com (8.12.9-20030918-01/8.12.9/d: major-outer.mc,v 1.15 2004/01/30 18:16:28 root Exp $) with ESMTP id i2NI5nOE005248
	for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2004 18:05:50 GMT
Received: from orsmsxvs041.jf.intel.com (orsmsxvs041.jf.intel.com [192.168.65.54])
	by talaria.jf.intel.com (8.12.9-20030918-01/8.12.9/d: major-inner.mc,v 1.10 2004/03/01 19:21:36 root Exp $) with SMTP id i2NHttgb013445
	for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2004 17:56:40 GMT
Received: from orsmsx332.amr.corp.intel.com ([192.168.65.60])
 by orsmsxvs041.jf.intel.com (SAVSMTP 3.1.2.35) with SMTP id M2004032310031701926
 for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2004 10:03:17 -0800
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a Linux system running 2.6.3 kernel, udev v 22.  I have an array
of Qlogic Disk array which shows up as a SCSI device to the kernel.
 
Now, when I do virtual insertion/deletion of devices, rules get called
and Device entries get created/deleted.  ( using sysfs interface to
delete or Scan new devices ).
 
Now, when I do physical insertion/deletions, the deletions do not work.
The sysfs Sub-system still shows the device under /sys although the
device has been physically Removed.

Is this is Qlogic driver problem or a SCSI sub-system problem ? In
syslog,
The LIP up/down events are detected. 

Thanks,

Atul

>-------------------------------------------------------------
>P.S:  All opinions are my personal opinion(s) & responsibility and do
>not represent the view of my employer ( Intel Corporation ).
