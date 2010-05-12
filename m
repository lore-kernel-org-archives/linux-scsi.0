From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Wed, 12 May 2010 09:33:18 GMT
Message-ID: <201005120933.o4C9XI7Q023861@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56429 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0ELJdS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 05:33:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4C9XIcR023863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 12 May 2010 09:33:18 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #23 from Brian Sullivan <bexamous@gmail.com>  2010-05-12 09:33:13 ---
>
> Can you give the drive makes and models too?  Some recent WD drives can
> lock-up
> on SMART with all controllers.


1,1  /dev/sdq unmounted                           WDC WD10EADS-00L:1A01
WD-WCAU46815978
2,1  /dev/sdp unmounted                           WDC WD10EADS-00L:1A01
WD-WCAU46783271
3,1  /dev/sdo unmounted                           WDC WD10EADS-00L:1A01
WD-WCAU46803203
4,1  /dev/sdn unmounted                           WDC WD1000FYPS-0:1B01
WD-WCASJ0318455
1,2  /dev/sdi unmounted                           WDC WD10EACS-00D:1A01
WD-WCAU42580399
2,2  /dev/sdh unmounted                           WDC WD10EACS-00D:1A01
WD-WCAU42557087
3,2  /dev/sdg unmounted                           WDC WD10EADS-00L:1A01
WD-WCAU46812587
4,2  /dev/sdf unmounted                           WDC WD15EADS-00H:0K05
WD-WCAUP0019266
1,3  /dev/sde unmounted                           WDC WD20EADS-00S:0A01
WD-WCAVY2526737
2,3  /dev/sdd unmounted                           WDC WD20EADS-00S:0A01
WD-WCAVY2252304
3,3  (empty)
4,3  (empty)
1,4  /dev/sdm unmounted                           Hitachi HDS72202:A20N
JK1130YAGVZSRT
2,4  /dev/sdl unmounted                           WDC WD20EADS-00S:0A01
WD-WCAVY1361632
3,4  /dev/sdk unmounted                           WDC WD20EADS-00S:0A01
WD-WCAVY1338263
4,4  /dev/sdj unmounted                           WDC WD20EADS-00S:0A01
WD-WCAVY1279474
1,5  /dev/sdr unmounted                           WDC WD20EADS-00R:0A01
WD-WCAVY1985273
2,5  /dev/sds unmounted                           WDC WD20EADS-00R:0A01
WD-WCAVY1861891
3,5  /dev/sdt unmounted                           WDC WD20EADS-00R:0A01
WD-WCAVY1985283
4,5  /dev/sdu unmounted                           WDC WD20EADS-00R:0A01
WD-WCAVY1831784

I have some more Hitatchi drives, but I am pretty sure at some point I
compared WD to Hitatchi and had problems with both.

Maybe next weekend if I have some time I'll try pulling all the WD drives
and adding some more Hitatchi and seeing what happens.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
