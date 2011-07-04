From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Mon, 4 Jul 2011 22:44:25 GMT
Message-ID: <201107042244.p64MiPWD020216@demeter1.kernel.org>
References: <bug-14534-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:34467 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1GDWo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2011 18:44:26 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p64MiPAE020218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jul 2011 22:44:25 GMT
In-Reply-To: <bug-14534-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14534


Stonefish <iamthestonefishdammit@hotmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |iamthestonefishdammit@hotma
                   |                            |il.com




--- Comment #11 from Stonefish <iamthestonefishdammit@hotmail.com>  2011-07-04 22:44:11 ---
Greetings all,

I'm receiving a very similar problem to this, and have been doing so ever since
I got three of those same Supermicro AOC-SASLP-MV8 cards six months back.  I'm
currently running just one, but that doesn't help.

I've created a software raid5, and it's usable.  When this error strikes, it
does recover.  IO performance drops to zero for about a minute or three, but it
does come back.  Almost always :)
I've tried several kernels since about 2.6.34, vanilla and gentoo alike. 
Currently on 2.6.39.2.

I was able to write some 140GB of random data to the array yesterday, and it
didn't fail until I started running a kvm instance and writing to the virtual
disk on it.  That kills it every time.
If I don't write large quantities of the data to the array, it remains quite
stable.  I'm able to read at excellent speeds.
The disks are Seagate ST31500341AS

I'll attach a log file.  Is there anything else anyone needs?

Cheers.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
