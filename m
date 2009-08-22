From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
Subject: [PATCH] usb: fix paths in usbmon documentation
Date: Sat, 22 Aug 2009 17:33:53 -0300
Message-ID: <20090822203353.GA2103@ime.usp.br>
References: <20090820220740.GA767@ime.usp.br>
 <Pine.LNX.4.44L0.0908211003090.2912-100000@iolanthe.rowland.org>
 <20090822191420.GA5572@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout1.uol.com.br ([200.221.4.192]:34783 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932646AbZHVUd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2009 16:33:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by socom1.uol.com.br (Postfix) with ESMTP id A38C41AA
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2009 17:33:59 -0300 (BRT)
Received: from chagas.nectar.ath.cx (unknown [187.22.248.83])
	by socom1.uol.com.br (Postfix) with ESMTPA id 595EDB0
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2009 17:33:54 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <20090822191420.GA5572@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org

Hi there.

On Aug 21 2009, Alan Stern wrote:
> On Thu, 20 Aug 2009, Rog=C3=A9rio Brito wrote:
> > Again, just reiterating, what I said before, even though I am not s=
ure
> > if I can reproduce it, I will try to.
>=20
> A usbmon trace showing what happens when you plug in the drive and=20
> when you run smartctl would help.

The documentation for usbmon in the kernel 2.6.31-rc7 kernel doesn't
match what the kernel exposes in the debug fs tree. This patch fixes it=
=2E

Signed-off-by: Rog=C3=A9rio Brito <rbrito@ime.usp.br>

---

diff --git a/Documentation/usb/usbmon.txt b/Documentation/usb/usbmon.tx=
t
index 6c3c625..ea05cf7 100644
--- a/Documentation/usb/usbmon.txt
+++ b/Documentation/usb/usbmon.txt
@@ -33,7 +33,7 @@ if usbmon is built into the kernel.
=20
 Verify that bus sockets are present.
=20
-# ls /sys/kernel/debug/usbmon
+# ls /sys/kernel/debug/usb/usbmon
 0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
 #
=20
@@ -58,11 +58,11 @@ Bus=3D03 means it's bus 3.
=20
 3. Start 'cat'
=20
-# cat /sys/kernel/debug/usbmon/3u > /tmp/1.mon.out
+# cat /sys/kernel/debug/usb/usbmon/3u > /tmp/1.mon.out
=20
 to listen on a single bus, otherwise, to listen on all buses, type:
=20
-# cat /sys/kernel/debug/usbmon/0u > /tmp/1.mon.out
+# cat /sys/kernel/debug/usb/usbmon/0u > /tmp/1.mon.out
=20
 This process will be reading until killed. Naturally, the output can b=
e
 redirected to a desirable location. This is preferred, because it is g=
oing


--=20
Rog=C3=A9rio Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2C=
AEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
