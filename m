From: Gabriel C <nix.or.die@googlemail.com>
Subject: [SCSI] SD driver question
Date: Wed, 04 Jul 2007 18:44:12 +0200
Message-ID: <468BCE5C.6000707@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:32170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbXGDQoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 12:44:16 -0400
Received: by ug-out-1314.google.com with SMTP id j3so325164ugf
        for <linux-scsi@vger.kernel.org>; Wed, 04 Jul 2007 09:44:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Hello,

Is there any reason why sd is printing the driver informations for each 
disk twice in dmesg ?

...

sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0

etc
...


Is a bit annoying and floodish ;) on boxes with a lot SCSI , *ATA disks.


Regards,

Gabriel C


