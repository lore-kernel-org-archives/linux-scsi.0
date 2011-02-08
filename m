From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Why using configfs as the only interface is wrong for a storage
 target
Date: Tue, 8 Feb 2011 09:01:58 +0100
Message-ID: <20110208090158.68939a8f@galadriel2.home>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
	<20110207115347.GA7503@noexit>
	<1297089709.3012.19.camel@mulgrave.site>
	<20110207160223.598210a2@harpe.intellique.com>
	<1297109379.13752.250.camel@haakon2.linux-iscsi.org>
	<20110207223845.71d2ab18@galadriel2.home>
	<20110207224407.GC13518@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:44739 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1BHIDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2011 03:03:20 -0500
In-Reply-To: <20110207224407.GC13518@noexit>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <jlbec@evilplan.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

Le Mon, 7 Feb 2011 14:44:09 -0800 vous =C3=A9criviez:

> They should be isolating the "how I send it down to the kernel" from
> your average admin.  Whether that config is a simple text file or a
> complex scripty mess is independent of this.  One would hope that,
> like mdadm(8), you have a simple human-readable text file that a
> program turns into the proper kernel invocation.

Gosh, ex-act-ly.

> 	It's great that Nick has fancy tools to fly around the target
> configfs space, but that's all fluff for people writing and debugging
> the tools.  Same with mdadm(8) and the MD ioctl(2)s.  You don't want
> to know the details of the ioctl(2) call; you just want mdadm(8) to
> work.

I understand that we can't overnight get rid of sysctl and stuff.
So far configfs looks like one more kernel configuration subsystem
usable only with ocfs and lio. What I'm afraid of is several
different configuration systems living side by side for the next 10
years in the kernel.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
