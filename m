From: Joerg Schilling <schilling@fokus.fraunhofer.de>
Subject: Re: [PATCH] Make scsi.h nominally userspace-clean
Date: Mon, 9 Aug 2004 19:53:42 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408091753.i79Hrg9q010822@burner.fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:56499 "EHLO
	mailhub.fokus.fraunhofer.de") by vger.kernel.org with ESMTP
	id S266798AbUHIRyZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 13:54:25 -0400
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, noah@cs.caltech.edu
Cc: James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, schilling@fokus.fraunhofer.de

>From axboe@suse.de  Mon Aug  9 19:52:11 2004

>> scsi/scsi.h does not compile cleanly in userspace programs due to it=
s
>> use of ``u8''.  I have confirmed this bug and prepared and tested a
>> fix that simply changes all such uses to ``__u8''.  Please consider
>> for inclusion.
>>=20
>> I do not argue that including this header file in a program is
>> appropriate, but other kernel headers already take as many precautio=
ns
>> as this patch introduces.  I chose __u8 over uint8_t as more in the
>> style of the kernel generally.
>>=20
>> Please keep me on cc:; I do not subscribe to the lists.

>I already sent such a patch to Linus.

thank you! Did you also send a patch for sg.h to include linux/compiler=
=2Eh?

J=F6rg

--=20
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) J=F6rg Schilling D-1335=
3 Berlin
       js@cs.tu-berlin.de		(uni)  If you don't have iso-8859-1
       schilling@fokus.fraunhofer.de	(work) chars I am J"org Schilling
 URL:  http://www.fokus.fraunhofer.de/usr/schilling ftp://ftp.berlios.d=
e/pub/schily
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
