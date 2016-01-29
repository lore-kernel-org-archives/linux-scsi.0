From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 03:40:42 +0000
Message-ID: <bug-111441-11613-w4x2QYQuNE@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60374 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbcA2Dkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 22:40:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EF8A52014A
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 03:40:45 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 29B4A20374
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 03:40:43 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

--- Comment #4 from Serguei Bezverkhi <sbezverk@cisco.com> ---
with kernel 4.4.0

lsscsi 
[0:0:44:0]   enclosu CISCO    UCS 240          0809  -        
[0:2:0:0]    disk    LSI      MR9261-8i        2.13  /dev/sda 
[0:2:1:0]    disk    LSI      MR9261-8i        2.13  /dev/sdb 
[3:0:0:2]    type?   vendor?  model?           rev?  -        
[4:0:0:3]    type?   vendor?  model?           rev?  -        
[5:0:0:1]    type?   vendor?  model?           rev?  -        
[6:0:0:4]    type?   vendor?  model?           rev?  -        
[7:0:0:0]    type?   vendor?  model?           rev?  -        
[8:0:0:0]    type?   vendor?  model?           rev?  -    

with kernel 3.10.0-327.4.4

lsscsi 
[0:0:44:0]   enclosu CISCO    UCS 240          0809  -        
[0:2:0:0]    disk    LSI      MR9261-8i        2.13  /dev/sda 
[0:2:1:0]    disk    LSI      MR9261-8i        2.13  /dev/sdb 
[3:0:0:2]    disk    LIO-ORG  san-disk-2       4.0   /dev/sdc 
[4:0:0:3]    disk    LIO-ORG  san-disk-3       4.0   /dev/sdd 
[5:0:0:1]    disk    LIO-ORG  san-disk-1       4.0   /dev/sde 
[6:0:0:4]    disk    LIO-ORG  san-disk-4       4.0   /dev/sdf

-- 
You are receiving this mail because:
You are the assignee for the bug.
