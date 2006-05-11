From: "Chhavi Agarwal" <Chhavi.Agarwal@patni.com>
Subject: unknown symbol scsi_bus_type
Date: Thu, 11 May 2006 13:11:30 +0530
Message-ID: <00d601c674ce$520f0980$f4041aac@pcp42816>
Reply-To: <Chhavi.Agarwal@patni.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1147333281-11516-70"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcsbom.patni.com ([203.124.139.208]:60133 "EHLO
	pcsspz.PATNI.COM") by vger.kernel.org with ESMTP id S965195AbWEKHj5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 03:39:57 -0400
Received: from rakshak.patni.com (rakshak.patni.com [203.124.139.211])
	by pcsspz.PATNI.COM (8.12.8/8.12.8) with SMTP id k4B7h676030302
	for <linux-scsi@vger.kernel.org>; Thu, 11 May 2006 13:13:15 +0530
Received: from spzha1.patni.com ([192.168.0.6])
 by rakshak.patni.com (SMSSMTP 4.1.11.41) with SMTP id M2006051113150807344
 for <linux-scsi@vger.kernel.org>; Thu, 11 May 2006 13:15:08 +0530
Received: from pcp42816 ([172.26.4.244])
	(authenticated bits=0)
	by spzha1.patni.com (8.13.4/8.12.9) with ESMTP id k4B7fLF5026535
	for <linux-scsi@vger.kernel.org>; Thu, 11 May 2006 13:11:21 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-Scsi (E-mail)" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format...

------------=_1147333281-11516-70
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I am using a linux-2.6.14 kernel.
I am trying to load my iSCSI module but when using insmod the error is

insmod: error inserting 'unh_scsi_target.ko': -1 Unknown symbol in module

linux:/home/chhavi/unh_iscsi.1.6.00/src # dmesg
unh_scsi_target: Unknown symbol scsi_bus_type

I had exported scsi_bus_type and rebuild the kernel.
its seen as exported in module.symvers.

but still the error persists.

any help will be appreciated.

Thanks


http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail. 
_____________________________________________________________________

------------=_1147333281-11516-70--
