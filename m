From: Peter Backlund <peter.backlund@home.se>
Subject: Driver request: ITE8212
Date: Wed, 04 Aug 2004 09:46:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091605611.3299.16.camel@h194n2fls33o1121.telia.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from av1-2-sn3.vrr.skanova.net ([81.228.9.106]:416 "EHLO
	av1-2-sn3.vrr.skanova.net") by vger.kernel.org with ESMTP
	id S267303AbUHDHmh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 03:42:37 -0400
Received: from smtp4-2-sn2.hy.skanova.net (smtp4-2-sn2.hy.skanova.net [81.228.8.93])
	by av1-2-sn3.vrr.skanova.net (Postfix) with ESMTP id BCB0B37F11
	for <linux-scsi@vger.kernel.org>; Wed,  4 Aug 2004 09:42:36 +0200 (CEST)
Received: from [217.211.80.194] (h194n2fls33o1121.telia.com [217.211.80.194])
	by smtp4-2-sn2.hy.skanova.net (Postfix) with ESMTP id 93E9537E49
	for <linux-scsi@vger.kernel.org>; Wed,  4 Aug 2004 09:42:36 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello.

I'd like to propose to the inclusion of the ITE 8212 Raid controller
card. The manufacturer already provides a GPL driver (one for 2.4.x and
one for 2.6.x) and a lot of hardware specs.

HW spec (pdf):

http://www.ite.com.tw//pc/IT8212F_V04.pdf

Driver source:

http://www.ite.com.tw//pc/LinuxDriverSrc_it8212_092005-09.zip

Overview:

http://www.ite.com.tw//productInfo/Download.html#IT8212F

There is also source code for the 8211F driver, which would also be nice
to include.

I own a ITE8212 controller, and I would be happy to help with any
testing etc. It seems that the card is available in two different
versions, one (hardware) RAID and one simple 4-channel IDE controller.  

I know this is the scsi list, but from playing around with the driver I
noticed that it uses the ide-scsi subsystem and that it seems to have
fallen out of sync with recent changes in scsi/scsi_*.h (only guessing
here). It is also quite buggy :-/   

Regards,

Peter Backlund


