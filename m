From: Daniel Drake <dsd@gentoo.org>
Subject: 2.6.27 looping on SCSI errors for bad sectors
Date: Thu, 11 Dec 2008 20:36:51 +0000
Message-ID: <494179E3.30802@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:35587 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756708AbYLKUpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 15:45:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

Hi Alan,

I'm aware of your work at http://bugzilla.kernel.org/show_bug.cgi?id=11843

I agree with fixing the unusual_devs file for USB devices that report 
the wrong capacity, but this SCSI "looping on error" problem reaches 
further than that. Gentoo has a bug report at 
https://bugs.gentoo.org/show_bug.cgi?id=248698 where there is a "real" 
bad sector in the middle of a disk, and this bug is affecting recovery 
of said disk.

On the kernel bugzilla you posted some patches that would improve the 
behaviour of 2.6.27 here. Are those patches candidates for 2.6.27.x, or 
do you know if it's being fixed another way, or is it a lost cause?
I understand that 2.6.28 has been fixed through a major rework in that area.

Thanks,
Daniel
