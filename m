From: Sergiu <constantin.srg@gmail.com>
Subject: Re: Why using configfs as the only interface is wrong for a storage target
Date: Wed, 16 Sep 2015 07:34:13 +0000 (UTC)
Message-ID: <loom.20150916T091909-802@post.gmane.org>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>	 <20110207115347.GA7503@noexit> <1297089709.3012.19.camel@mulgrave.site> <4D500B66.5000103@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39570 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbbIPHkO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2015 03:40:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1Zc7K2-000311-8V
	for linux-scsi@vger.kernel.org; Wed, 16 Sep 2015 09:40:06 +0200
Received: from gate2.itcnetworks.ro ([82.78.3.253])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 09:40:06 +0200
Received: from constantin.srg by gate2.itcnetworks.ro with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 09:40:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello all,

I have an issue related to this topic. I am trying to detect via a libudev
wrapper if device based on configfs is mounted. 
I have a small usb detector based on libudev and libudev(the wapper),
"udev_enumerate_add_match_subsystem( enumerate, "usb" )" is used as a filter
and I mount the a device using 'mount none /cfg1 -t configfs'.
Linux detects the device as mounted but udev detector does not. Do you know
if what I am trying to do is possible, to mount a file based on configfs,
and edit the structure so that it is detected by udev? I edited the vendor
id, the product id, class id in the configfs structure but the detector does
not see it.

Thank in advance,
Sergiu



