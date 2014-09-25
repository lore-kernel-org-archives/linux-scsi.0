From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Thu, 25 Sep 2014 22:42:57 +0000
Message-ID: <bug-85101-11613-2oEC3ATEjg@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46146 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaIYWnA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 18:43:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 67630202E6
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 22:42:59 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D48CB202AE
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 22:42:57 +0000 (UTC)
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

--- Comment #8 from linux-ide@crashplan.pro ---
Confirmation of successful firmware download/update/flash to the HP SAS
expander card using the commands:
# sg_write_buffer --mode=dmc_offs_defer --bpw=4096 --in=PUF21000.bin /dev/sg1
# sg_write_buffer --mode=activate_mc /dev/sg1
# reboot

# lsscsi -g | grep HP
[6:0:0:0]    enclosu HP       HP SAS EXP Card  2.10  -          /dev/sg1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
