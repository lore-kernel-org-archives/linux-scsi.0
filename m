From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16275] Kernel panic when mounting filesystem
Date: Mon, 26 Jul 2010 14:44:19 GMT
Message-ID: <201007261444.o6QEiJC8003065@demeter.kernel.org>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36213 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab0GZOoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2010 10:44:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6QEiJwC003066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2010 14:44:19 GMT
In-Reply-To: <bug-16275-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16275





--- Comment #21 from Pawel Staszewski <pstaszewski@artcom.pl>  2010-07-26 14:44:14 ---
Ok i reproduce this on VirtualBox with md and raid1.
Changes that i made:

const bool -> const unsigned long (where was do_sync function)
and 
bool do_barriers; -> unsigned long do_barriers;

Now i have:
Kernel BUG at fs/inode.c:298!

Picture from trace in attached file: panic_unsigned_long.jpg

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
