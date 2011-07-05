From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Tue, 5 Jul 2011 08:25:39 GMT
Message-ID: <201107050825.p658Pdk6017043@demeter2.kernel.org>
References: <bug-14534-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39486 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1GEIZk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2011 04:25:40 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p658PdjA017044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 5 Jul 2011 08:25:39 GMT
In-Reply-To: <bug-14534-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14534


taeuber@bbaw.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |taeuber@bbaw.de




--- Comment #13 from taeuber@bbaw.de  2011-07-05 08:25:37 ---
Hello,

it seems my problem is also related to the mvsas driver/scsi subsystem:
http://thread.gmane.org/gmane.linux.kernel/1150608

I can reproduce the problem with a simple:
dd if=/dev/zero of=/dev/sdc

I tested this with the newest stable kernel 2.6.39.2 and two different
enterprise SATA drives:
* Seagate Constellation ES
* Hitachi Ultrastar 7k3000

I'd like to help debugging this.
Please give some instructions.

Lars

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
