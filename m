From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Wed, 12 May 2010 10:22:12 GMT
Message-ID: <201005121022.o4CAMCt8016468@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41271 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0ELKWO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 06:22:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4CAMDdr016472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 12 May 2010 10:22:13 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #24 from Tim Small <tim@seoss.co.uk>  2010-05-12 10:22:08 ---
(In reply to comment #23)

> 3,1  /dev/sdo unmounted                           WDC WD10EADS-00L:1A01
> WD-WCAU46803203
> 4,1  /dev/sdn unmounted                           WDC WD1000FYPS-0:1B01
> WD-WCASJ0318455
> 1,2  /dev/sdi unmounted                           WDC WD10EACS-00D:1A01
> WD-WCAU42580399
> 2,2  /dev/sdh unmounted                           WDC WD10EACS-00D:1A01
> WD-WCAU42557087
> 3,2  /dev/sdg unmounted                           WDC WD10EADS-00L:1A01
> WD-WCAU46812587
> 4,2  /dev/sdf unmounted                           WDC WD15EADS-00H:0K05
> WD-WCAUP0019266

> Maybe next weekend if I have some time I'll try pulling all the WD drives
> and adding some more Hitatchi and seeing what happens.

Perhaps you could stress-test the drives on a different controller e.g. AHCI,
PIIX, Silicon Image, or whatever?

Tim.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
