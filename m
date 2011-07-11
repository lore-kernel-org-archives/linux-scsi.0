From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Mon, 11 Jul 2011 04:56:54 GMT
Message-ID: <201107110456.p6B4us2X029284@demeter2.kernel.org>
References: <bug-14534-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:41836 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1GKE4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2011 00:56:54 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p6B4usDX029285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2011 04:56:54 GMT
In-Reply-To: <bug-14534-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14534





--- Comment #14 from Stonefish <iamthestonefishdammit@hotmail.com>  2011-07-11 04:56:49 ---
Please note that I've updated to the latest firmware on the AOC-SASLP-MV8, and
it didn't help any.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
