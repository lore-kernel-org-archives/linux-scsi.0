From: "Sabharwal, Atul" <atul.sabharwal@intel.com>
Subject: SCSI rescan operation
Date: Thu, 1 Jul 2004 17:07:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <66539F0E7F15B44C9C0FC50D0FF024F7CB7077@orsmsx407>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr09.intel.com ([192.52.57.35]:51670 "EHLO hermes.hd.intel.com")
	by vger.kernel.org with ESMTP id S265814AbUGBAIH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2004 20:08:07 -0400
Received: from petasus.hd.intel.com (petasus.hd.intel.com [10.127.45.3])
	by hermes.hd.intel.com (8.12.9-20030918-01/8.12.9/d: large-outer.mc,v 1.9 2004/01/09 00:55:23 root Exp $) with ESMTP id i62086qG029889
	for <linux-scsi@vger.kernel.org>; Fri, 2 Jul 2004 00:08:06 GMT
Received: from orsmsxvs041.jf.intel.com (orsmsxvs041.jf.intel.com [192.168.65.54])
	by petasus.hd.intel.com (8.12.9-20030918-01/8.12.9/d: large-inner.mc,v 1.10 2004/03/01 19:22:27 root Exp $) with SMTP id i62085JH020257
	for <linux-scsi@vger.kernel.org>; Fri, 2 Jul 2004 00:08:06 GMT
Received: from orsmsx331.amr.corp.intel.com ([192.168.65.56])
 by orsmsxvs041.jf.intel.com (SAVSMTP 3.1.2.35) with SMTP id M2004070117080510516
 for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2004 17:08:05 -0700
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Caushik, Ramesh" <ramesh.caushik@intel.com>

Folks,

I am using SCSI re-scan via the sysfs interface. Does SCSI re-scan
insert and delete
devices from sysfs file system?  If I logically delete a device, can I
do a rescan 
and find the device ?

What is the kind of driver support required.  I am currently using
qlogic driver for
A storage blade in an ATCA system and SCSI rescan is roughly doing
nothing.
The kernel is 2.6.6.

If I remove the cable and do a re-scan, the devices should get deleted
but it does
Not happen.  Even when I check the fc_transport, the device folders
still exist.

Any help is appreciated.

Thanks,

Atul

-------------------------------------------------------------
P.S:  All opinions are my personal opinion(s) & responsibility and do
not represent the view of my employer ( Intel Corporation ).

