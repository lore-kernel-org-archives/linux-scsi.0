From: Joern Quillman <quillman@fbihome.de>
Subject: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Fri, 17 Nov 2006 18:38:34 +0100
Message-ID: <455DF39A.6090209@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:13536 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S933027AbWKQRkz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 12:40:55 -0500
Received: from [192.168.1.30]
	by eis.satan.lan with esmtpa (Exim 4.60)
	(envelope-from <quillman@fbihome.de>)
	id 1Gl9f6-0000ke-CX
	for linux-scsi@vger.kernel.org; Fri, 17 Nov 2006 19:46:10 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I'm having troubles using the sysfs interface for enabling automatic 
spinup of SCSI Drives.
I searched the archives of this list and after discovering the patches 
for enabling automatic spinup for SCSI disk drives I updated to a recent 
2.6.18-2 kernel (debian unstable).
I have now the allow_restart entry in sysfs.
It's set to 0 in my machine and it won't let me change it with 'echo 1 > 
allow_restart' or echo -n. I always get a write error.

The first thing I thought about was that it may be set to 0 by default 
and so I took a look into the original source of my debian kernel.
It's set to 'sdev->allow_restart = 1' everywhere in the source as I can 
see and I'm getting confused right now.
Why can't I change the allow_restart setting at runtime? According to 
former posts on this list it should be possible.

Is there another way to force automatic spinup of my firewire drives?

My setup consists of a bunch of 8 IDE harddisks connected through some 
OXFW911 Firewire Bridges.

Thanks

Joern

