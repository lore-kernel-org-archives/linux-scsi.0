From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Fri, 16 Aug 2013 23:32:02 +0000
Message-ID: <bug-60758-11613-SWHNAtCOMl@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53866 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab3HQAKI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Aug 2013 20:10:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A12CE20345
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2013 23:32:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 03D682022D
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2013 23:32:03 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #2 from zakrzewskim@wp.pl ---
Sorry that was my grub.conf.

Here's fstab:

proc /proc proc defaults 0 0
devpts /dev/pts devpts gid=5,mode=620 0 0
tmpfs /dev/shm tmpfs defaults 0 0
sysfs /sys sysfs defaults 0 0
/dev/md0 none           swap  sw                                               
                                                              0       0
/dev/md1 /boot          ext4  defaults                                         
             0       1
/dev/md2 /              ext4 
rw,discard,noatime,nodiratime,usrjquota=aquota.user,grpjquota=aquota.group,usrquota,grpquota,jqfmt=vfsv0
       0       1
/dev/md3 /var/lib/mysql ext4 
rw,discard,noatime,nodiratime,usrjquota=aquota.user,grpjquota=aquota.group,usrquota,grpquota,jqfmt=vfsv0
       0       0
/dev/md4 /home          ext4 
rw,noatime,nodiratime,usrjquota=aquota.user,grpjquota=aquota.group,usrquota,grpquota,jqfmt=vfsv0
               0       0

-- 
You are receiving this mail because:
You are the assignee for the bug.
