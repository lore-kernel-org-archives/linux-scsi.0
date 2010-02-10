From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Wed, 10 Feb 2010 10:27:42 GMT
Message-ID: <201002101027.o1AARgZg025384@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46542 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0BJK1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2010 05:27:43 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1AARg3H025399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2010 10:27:42 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


Martin Pitt <martin.pitt@ubuntu.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |martin.pitt@ubuntu.com




--- Comment #29 from Martin Pitt <martin.pitt@ubuntu.com>  2010-02-10 10:26:40 ---
> Every report so far has been of the Optiarc_DVD_RW_AD_7580S drive. Is there
> anyone who has seen this issue on any other drive?

The downstream bug report also reported this to happen on a slightly different
model:

UDEV  [1243584928.060421] change  
/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
[...]
ID_VENDOR=Optiarc
ID_VENDOR_ENC=Optiarc\x20
ID_MODEL=DVD_RW_AD-7640S
ID_MODEL_ENC=DVD\x20RW\x20AD-7640S\x20
ID_REVISION=HJ01
ID_TYPE=cd

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
