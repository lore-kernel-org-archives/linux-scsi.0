From: Tore Anderson <tore@linpro.no>
Subject: Re: Disabling dev_loss_tmo?
Date: Wed, 14 Nov 2007 16:38:58 +0100
Message-ID: <473B1692.8050606@linpro.no>
References: <47396A5B.5040001@linpro.no> <4739CE69.3040602@emulex.com> <473AAD88.307@linpro.no> <473B0644.3090403@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:48999 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464AbXKNPjB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 10:39:01 -0500
In-Reply-To: <473B0644.3090403@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Michael Reed <mdr@sgi.com>, Christoph Hellwig <hch@infradead.org>, MLOEHR@de.ibm.com

* James Smart

> Please don't shoot the messenger. I was trying to summarize the
> evolution of FC into the kernel, highlight that the DM team knew of
> the issue, had higher-priority issues, and that it applies to more
> than FC.  Having experienced first-hand this method of getting work
> done, I certainly don't promote it as a productive way of doing
> things.

Sorry, didn't mean to shoot you!  ;-)  I mean "you" in the plural sense=
;
=C2=AByou SCSI people=C2=BB - got the impression there is some kind of =
disdain
towards the DM team (which would indeed be a counter-productive way of
getting things done).  Not my intention to offend anyone, and if I did
anyway I apologise.

It's just frusterating when things don't work...

> I'm highlighting that - ok today, we get FC working, but then the
> user puts DM on something else, like iSCSI or SAS/whatever, then it
> too breaks - and that's ok ?

Of course the best would be if it worked perfectly with all transports,
and leaving things broken is of course not OK.  In my strictly pragmati=
c
opinion, though, having a functional DM+FC combo and and half-functiona=
l
DM+<anything else> combos is better than having _only_ half-functional
combos.

> Using this analogy, to resolve the reuse-after-free issues, we simply
> would have used the dont-tear-down patches to avoid teardown bugs,=20
> like what the distros did.  This too is a bad approach. Things need
> to get fixed where things need to get fixed.  We can add the FC
> patch, but DM still needs to get fixed.

Best would to have DM-multipath handle the disconnects gracefully, of
course.  But since it doesn't appear to be happening anytime soon:  A
workaround provided by the transport layer would be very welcome!  I
don't use iSCSI or SAS with DM so I don't know if such a workaround is
wanted there too, but with FC it is necessary.  Even if it is a bad
approach it is much better than nothing, the way I see it.

Regards
--=20
Tore Anderson
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
