From: Edward Falk <efalk@google.com>
Subject: map gendisk (or blockdev) -> scsi_device
Date: Tue, 12 Jul 2005 17:38:19 -0700
Message-ID: <db1npr$c1d$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:27804 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S262534AbVGMAuz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 20:50:55 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1DsVS3-0006PU-I4
	for linux-scsi@vger.kernel.org; Wed, 13 Jul 2005 02:50:15 +0200
Received: from 216-239-45-4.google.com ([216.239.45.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 02:50:15 +0200
Received: from efalk by 216-239-45-4.google.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 02:50:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all; what's the proper way to get the scsi_device structure from a 
gendisk structure?  sd.c uses pointers through scsi_disk, but that 
structure is private to sd.c.  Will I need to add an access function in 
sd.c or something?

-ed falk, efalk@google.com

