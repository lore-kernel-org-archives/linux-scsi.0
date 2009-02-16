From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: timeout/hardreset a device manually?
Date: Mon, 16 Feb 2009 15:56:42 +0100
Message-ID: <49997EAA.7050604@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:36825 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZBPO4g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 09:56:36 -0500
Received: from localhost (filter1.syneticon.net [192.168.113.83])
	by mx03.syneticon.net (Postfix) with ESMTP id 0DDF936150
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2009 15:59:36 +0100 (CET)
Received: from mx03.syneticon.net ([192.168.113.84])
	by localhost (mx03.syneticon.net [192.168.113.83]) (amavisd-new, port 10025)
	with ESMTP id OCt+GP7dg99a for <linux-scsi@vger.kernel.org>;
	Mon, 16 Feb 2009 15:53:13 +0100 (CET)
Received: from [192.168.10.145] (koln-4db40a0e.pool.einsundeins.de [77.180.10.14])
	by mx03.syneticon.net (Postfix) with ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2009 15:59:34 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Is it possible to "timeout" and/or "hardreset" a device "manually"?

I'm trying to debug a weird system freeze, I think being able to make 
the device "timeout" and eventually "hardreset" would be helpful in 
diagnosing this problem.

In other words, I'd like to be able to "manually" achieve this:

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.00: cmd 35/00:08:3f:7c:93/00:00:2e:00:00/e0 tag 0 dma 4096 out
          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: hard resetting link
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: max_sectors limited to 256 for NCQ
ata1.00: max_sectors limited to 256 for NCQ
ata1.00: configured for UDMA/33
ata1: EH complete
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA


-- 
Tomasz Chmielewski
http://wpkg.org
