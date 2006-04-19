From: Orion Poplawski <orion@cora.nwra.com>
Subject: Vendor specific cdrom error messages
Date: Wed, 19 Apr 2006 10:26:14 -0600
Message-ID: <e25obb$2fp$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56215 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S1750990AbWDSQ07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 12:26:59 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1FWFVh-0004fa-VZ
	for linux-scsi@vger.kernel.org; Wed, 19 Apr 2006 18:26:34 +0200
Received: from inferno.cora.nwra.com ([65.125.157.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2006 18:26:33 +0200
Received: from orion by inferno.cora.nwra.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2006 18:26:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I got the following error trying to burn a DVD on an IBM USB2 DVD-R burner:

Nov  7 11:40:36 makani kernel: cdrom: This disc doesn't have any tracks 
I recognize!
Nov  7 11:41:59 makani kernel: sr 0:0:0:0: SCSI error: return code = 
0x8000002
Nov  7 11:41:59 makani kernel: sr0: Current: sense key: Data Protect
Nov  7 11:41:59 makani kernel:     ASC=0x27 <<vendor>> ASCQ=0xff

This is on Fedora Core 4 and kernel 2.6.13-1.1532_FC4.

It turns out that this is because the drive did not have enough power 
(it was not plugged into the separate ac adapter).  I was able to 
determine this by booting into Windows, which gave me a nice descriptive 
error message.

I was wondering if it makes sense for the kernel drivers to know these 
error messages and report better errors, of it should be left up to user 
space tools.

- Orion

