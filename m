From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35282] BUG() in 2.6.38.6
Date: Fri, 27 May 2011 09:53:07 GMT
Message-ID: <201105270953.p4R9r71E010345@demeter2.kernel.org>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:55106 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1E0JxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 05:53:08 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4R9r76T010346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2011 09:53:07 GMT
In-Reply-To: <bug-35282-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35282


Nils Kneuper <crazy-ivanovic@gmx.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |crazy-ivanovic@gmx.net




--- Comment #5 from Nils Kneuper <crazy-ivanovic@gmx.net>  2011-05-27 09:53:06 ---
I had some crashes over here, especially with 2.6.39, but also with some
2.6.38.*, kernel versions, too. Applied this patch about 24h ago and so far
there seem to be no further kernel panics. Since I know no way to actually get
the logs from the crashes, I just photographed them using my mobile phone:
http://imagebin.org/index.php?mode=image&id=155275
http://imagebin.org/index.php?mode=image&id=155274

As you can probably see they are not complete, some output is missing. My
general hardware/setup:
* AMD 64 vanilla kernel (2.6.39)
* Phenom II X6 1055T
* 8GB Ram
* Gigabyte GA-870A-UD3 (rev. 2.1)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
