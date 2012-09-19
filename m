From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 46031] kswapd0 moving to uninterruptible sleep (STAT D)
Date: Wed, 19 Sep 2012 08:01:07 +0000 (UTC)
Message-ID: <20120919080107.8A99111FB4B@bugzilla.kernel.org>
References: <bug-46031-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54814 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab2ISIBO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Sep 2012 04:01:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4050C20241
	for <linux-scsi@vger.kernel.org>; Wed, 19 Sep 2012 08:01:13 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1CEE420238
	for <linux-scsi@vger.kernel.org>; Wed, 19 Sep 2012 08:01:08 +0000 (UTC)
In-Reply-To: <bug-46031-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=46031


Markus Hetzmannseder <Markus.Hetzmannseder@jku.at> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #3 from Markus Hetzmannseder <Markus.Hetzmannseder@jku.at>  2012-09-19 08:01:07 ---
Thx for the help on it. As far as i could strip down the reasion for the
errors, its deffinitly something hardware related. I think there is something
wrong with the motherboard. 

Markus

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
