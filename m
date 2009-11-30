From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 2nd try] PCI legacy I/O port free driver - Making
 MegaRAID SAS driver
Date: Mon, 30 Nov 2009 12:14:16 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B7D0D20C@cosmail02.lsi.com>
References: <4AD52367.7050500@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60315 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbZK3T3l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2009 14:29:41 -0500
In-Reply-To: <4AD52367.7050500@np.css.fujitsu.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Noriyuki Fujii <n-fujii@np.css.fujitsu.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Noriyuki,

The patch looks good for us.  ACK.

Bo Yang  

-----Original Message-----
From: Noriyuki Fujii [mailto:n-fujii@np.css.fujitsu.com] 
Sent: Tuesday, October 13, 2009 9:04 PM
To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org
Subject: [PATCH 2nd try] PCI legacy I/O port free driver - Making MegaRAID SAS driver

Hi,

Here's my 2nd try of the following post.

http://marc.info/?l=linux-scsi&m=124962265606425&w=2

I made a patch for MegaRAID sas driver to make PCI legacy I/O port free.

The way to make PCI legacy I/O port free is the same as Fusion-MPT driver's and it has been merged into 2.6.30.4.

This has already been fixed in e1000 and lpfc.

As a result of the above, the driver can handle its device even when there are a huge number of PCI devices being used on the system and no I/O port region assigned to the device.

I'm not in the linux-scsi mailing list.
Please reply to the following address.

 E-Mail: n-fujii@np.css.fujitsu.com

Thanks,
Noriyuki Fujii

