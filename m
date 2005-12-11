From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Read-only paranoia during data recovery
Date: Sun, 11 Dec 2005 14:38:55 -0800
Message-ID: <9A6F28681255C988725DE82A@[10.0.0.14]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segw.microprecisionautomation.com ([69.17.55.168]:22227 "EHLO
	segw.microprecisionautomation.com") by vger.kernel.org with ESMTP
	id S1750893AbVLKWjo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Dec 2005 17:39:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a friend who needs to recover some data from a SCSI drive from a SCO 
system, and he wants to make sure nothing writes to the drive if he mounts 
it on his Linux system. I just want to verify that mounting it read-only is 
sufficient and won't attempt to write anything to it. (I recall in the old 
days when HD's had a write-protect jumper to protect it at the firmware 
level.) Are there other measures he should take?
