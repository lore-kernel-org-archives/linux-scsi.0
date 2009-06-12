From: walt <w41ter@gmail.com>
Subject: Question about scsi device names
Date: Thu, 11 Jun 2009 17:36:13 -0700
Message-ID: <h0s7tv$d8f$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48465 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZFLAg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2009 20:36:28 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MEuks-0002UR-1L
	for linux-scsi@vger.kernel.org; Fri, 12 Jun 2009 00:36:26 +0000
Received: from adsl-69-234-202-135.dsl.irvnca.pacbell.net ([69.234.202.135])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 00:36:26 +0000
Received: from w41ter by adsl-69-234-202-135.dsl.irvnca.pacbell.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 00:36:26 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi list,

Here is some background for my question:

I have a machine with two sata disks, one connected to the
onboard sata controller, the other to an add-on ESATA board
plugged into the PCIX slot.

My puzzle:

When I boot a kernel from the 2.6.28 series, the onboard
controller's disk gets dubbed /dev/sdb, and the ESATA disk
is /dev/sda.

When I boot the same machine with a more recent kernel like
Linus's 2.6.30 series, the device names are reversed.

Is this change in behavior expected based on recent kernel
patches?

Thanks.


