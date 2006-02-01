From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: Re:[PATCH, RFC] aic7xxx: semaphore to completion conversion
Date: Wed,  1 Feb 2006 23:23:02 +0100
Message-ID: <IU14UE$B54E7A6B1CA1787FCF410BBB75E09FBA@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:11876 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S1422981AbWBAWXT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Feb 2006 17:23:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Luben Tuikov <ltuikov@yahoo.com>

Hello,

Tested on 2.6.15 + James Bottomley "aic7xxx timer handling
bug" fix + "Turn off ordered flush barriers for SCSI driver"
from Jens Axboe.

Seems to work as expected.
I stressed the recovery code a lot with my magic command
(cdrwtool -d /dev/sr0 -q).
The card never recover but was not completely dead.
I was able to issue a reboot command and it complete correctly
(way sloooooww but complete).
The kernel trace are very clean and repetitive now.
I attach the complete log to
http://bugzilla.kernel.org/show_bug.cgi?id=3D5921

Luben, I know that you're not the aic maintainer but
pleeeaaasse, could you have a look at the kernel log attached
to this bugzilla bug ? Your Adaptec expertise is precious.

Regards,
Emmanuel.
---


Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
