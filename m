From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Disabling dev_loss_tmo?
Date: Wed, 14 Nov 2007 09:29:24 -0500
Message-ID: <473B0644.3090403@emulex.com>
References: <47396A5B.5040001@linpro.no> <4739CE69.3040602@emulex.com> <473AAD88.307@linpro.no>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55920 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbXKNO3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 09:29:55 -0500
In-Reply-To: <473AAD88.307@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Michael Reed <mdr@sgi.com>, Christoph Hellwig <hch@infradead.org>, MLOEHR@de.ibm.com

Tore Anderson wrote:
> So basically you're forcing breakage on users to corece the DM folks =
to
> fix their end?  Maybe it's time to re-think that strategy, seeing tha=
t
> it hasn't been fixed in such a long time it seems unlikely that they
> would start bothering now.  SuSE and RH works around it anyway, so
> everyone who's obedient enough to run the enterprise distros their
> storage vendor tells them to won't have any problems.  Many of the DM
> folks are employed by SuSE, RH, and various storage vendors - go figu=
re.

Please don't shoot the messenger. I was trying to summarize the evoluti=
on
of FC into the kernel, highlight that the DM team knew of the issue,
had higher-priority issues, and that it applies to more than FC.  Havin=
g
experienced first-hand this method of getting work done, I certainly
don't promote it as a productive way of doing things.

> I'm just a simple user.  To me the most important ting is that it - a=
nd
> by =C2=ABit=C2=BB I'm referring to the whole bundle of DM, SCSI, HBA =
driver, and
> the rest of the system - actually works.
>=20
> With no way of disabling dev_loss_tmo, it doesn't.  It will break aft=
er
> intermittent failures, exactly the time where you need it to work the
> most.  Knowing that the SCSI FC transport does the Right Thing isn't
> really any consolation.

I'm highlighting that - ok today, we get FC working, but then the user
puts DM on something else, like iSCSI or SAS/whatever, then it too
breaks - and that's ok ?

> The patch seems like a rather simple fix.  Quick and dirty, sure, but=
 it
> would actually help out the likes of me who are putting this stuff in
> production.  And if it defaulted to remove_on_dev_loss=3D0, it wouldn=
't
> really be intrusive either.  It seems that it will take a while to ge=
t
> this properly fixed (both in DM and the -EEXIST issue), so what I'm
> asking is just a way to make it work in the interim.

Using this analogy, to resolve the reuse-after-free issues, we simply
would have used the dont-tear-down patches to avoid teardown bugs,
like what the distros did.  This too is a bad approach. Things need to
get fixed where things need to get fixed.  We can add the FC patch, but
DM still needs to get fixed.

I'll defer to James on what he'd like to see happen in his subsystem,
as this does set precendence.

-- james s

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
