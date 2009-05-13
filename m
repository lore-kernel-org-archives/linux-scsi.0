From: "Phil Endecott" <phil_joqdm_endecott@chezphil.org>
Subject: Signal when device is disconnected
Date: Wed, 13 May 2009 18:49:05 +0100
Message-ID: <1242236945846@dmwebmail.dmwebmail.chezphil.org>
Mime-Version: 1.0
Content-Type: text/plain; format="flowed"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from japan.chezphil.org ([77.240.5.4]:5309 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759848AbZEMS0c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 14:26:32 -0400
Received: from localhost ([127.0.0.1] helo=chezphil.org)
	by japan.chezphil.org with esmtp (Exim 4.69)
	(envelope-from <phil_joqdm_endecott@chezphil.org>)
	id 1M4IZm-0004lI-R0
	for linux-scsi@vger.kernel.org; Wed, 13 May 2009 18:49:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear Experts,

The proc/bus/usb API has an ioctl that can arrange for the application 
to receive a signal when the device is disconnected.  Is there anything 
similar for the SCSI generic (or other SCSI) APIs?

Assuming that there isn't, I think I need to either poll the device to 
see if it's still there, or listen on a netlink socket for a removal 
uevent, or I need to find the USB device corresponding to the sg device 
that I'm using and use its signal-on-removal ioctl.  In the latter 
case, is there a way to traverse from an sg device's /sys directory to 
the corresponding usb device's /sys directory?  /sys seems to be full 
of symlinks but I can't find the one that I need in this case.

Basically I have a fairly simple user-space driver for a USB SCSI 
device that uses the SCSI-generic API, and I want it to terminate 
tidily when the device is detached.

Many thanks for any advice.


Phil.

(Please Cc: me in any replies.)



