From: Daniel Drake <dsd@gentoo.org>
Subject: BusLogic driver reports non-existent disks since VMware 1.0.4
Date: Sun, 16 Mar 2008 20:30:03 +0000
Message-ID: <47DD834B.9050807@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:32502 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbYCPUkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Mar 2008 16:40:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: lnz@dandelion.com

Hi,

There's no evidence that this is a BusLogic driver bug (as opposed to 
being a VMware bug), but as I couldn't find any mention on this list I 
thought I'd bring it to peoples attention:

If you upgrade from vmware 1.0.3 to 1.0.4, when using the BusLogic 
emulation (as opposed to LSI logic), the kernel reports existence of 
many disks that do not actually exist. Accessing those disks obviously 
causes hangs and error messages.

http://communities.vmware.com/thread/103939?tstart=0&start=0
https://bugs.gentoo.org/show_bug.cgi?id=198296

dmesg output from such a system:
https://bugs.gentoo.org/attachment.cgi?id=135371&action=view

This is similar but not the same as another vmware vs scsi driver problem:
http://marc.info/?l=linux-scsi&m=118590789115292&w=2
(that one is different and has been fixed in vmware)

If anyone is interested in investigating, I can pass on patches to 
people who can test them.

Daniel
