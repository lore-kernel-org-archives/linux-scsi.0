From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13602] some HFS CD-ROM's can't be read
Date: Sun, 31 Oct 2010 21:17:57 GMT
Message-ID: <201010312117.o9VLHvpb009435@demeter2.kernel.org>
References: <bug-13602-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:56099 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0JaVR6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2010 17:17:58 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9VLHwDe009443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 31 Oct 2010 21:17:58 GMT
In-Reply-To: <bug-13602-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13602





--- Comment #6 from Christoph Hellwig <hch@lst.de>  2010-10-31 21:17:53 ---
Old SGI, SUN and apparently mac systems did support CDROMs with 512 byte
sectors.  In MMC5 there is only a vague reference to them beeing supported by
the deprecated block descriptors taken from older SPC specs in some drives.

Searching on the internet implies you need very specific CDROM drives to use
the SGI/SUN 512 byte sector CDROMs.

I think we safely say there is no way to properly support this in Linux and we
we can close this bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
