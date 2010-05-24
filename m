From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Mon, 24 May 2010 09:05:14 GMT
Message-ID: <201005240905.o4O95EfA017205@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36797 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0EXJFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2010 05:05:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4O95Ea2017206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 May 2010 09:05:14 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D14831


dujun@perabytes.com changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |dujun@perabytes.com




--- Comment #25 from dujun@perabytes.com  2010-05-24 09:05:10 ---
https://bugzilla.kernel.org/show_bug.cgi?id=3D16021=20
we have a similar problem which I described in above bug report. Ryan t=
old me
about this patch work and I have it tested in our system. It seems that=
 it
works, and the md raid rebuild speed is around 60MB/s for 16 hdd.=20

However, the dd speed for when raid 5 is rebuiding is much less than or=
iginal
result. Around 150MB/s for write compared with almost 400MB/s without t=
he
patch. 600MB/s for read compared with 800MB/s.=20

Is this caused by the bounce buffer for the alignment?=E3=80=80Is there=
 any way to
solve this problem in lsi formware so that we don't need a forced align=
ment?=20

We will test the software raid grow problem reported by Brian later.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
