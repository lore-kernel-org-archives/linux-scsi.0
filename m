From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Fwd: Re: Problem with Linux aic94xx driver
Date: Sat, 30 Dec 2006 18:40:56 -0800 (PST)
Message-ID: <872564.54821.qm@web31810.mail.mud.yahoo.com>
References: <4596D8B7.2080005@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:44213 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752475AbWLaCk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Dec 2006 21:40:57 -0500
In-Reply-To: <4596D8B7.2080005@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, terje.rosten@ntnu.no
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

--- "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> --- Terje R=F8sten <terje.rosten@ntnu.no> wrote:
>=20
> > (It's 4 Western Digital RE2 WD5000YS with NCQ (500 GB SATA) on the
> > controller,
> > set up in RAID BIOS  to one RAID 1+0 logical drive).
>=20
> I suppose this may be a moot point since Mr. R=F8sten bought a better
> controller, but for the record, there exists another SAS stack that a=
lso
> does not have this bug (namely, the entire lack of SATA support):
>=20
> http://www.kernel.org/git/?p=3Dlinux/kernel/git/jejb/aic94xx-sas-2.6.=
git;a=3Dsummary

And there exists the original SAS Stack _with_ SATA support, _without_ =
this
bug, which I distribute.  I'm not sure if Terje was aware of it.

I think it is clear from his letter that he wanted SATA support.  Why w=
ould
he use a SAS Stack which has no SATA support, and thus trivially wouldn=
't
exhibit this bug, as per your suggestion...

This all of course begs the question: Why is there such a blatant
bug in the "master" branch of the Linux kernel for this driver?
Yep, I'm looking at tag v2.6.20-rc2 and it is right there where he
pointed out that it is.  The commit introducing it is
2908d778ab3e244900c310974e1fc1c69066e450, and it is one blob commit,
without previous git history, only the log message.

You seem to have replied to an email which I posted to linux-scsi, i.e.
my email is in the To: header.  You also seem to have edited the mail
headers to remove me from the CC/To list which is automatically built w=
hen
one replies to a message.

Removing people from CC lists is considered impolite. Adding people=20
is ok.

   Luben

> There are various stability/functionality fixes for that stack that a=
re
> under development as well:
>=20
> http://sweaglesw.net/~djwong/docs/sas_ata-patches/
>=20
> That said, even if Mr. R=F8sten had built a driver with SATA support,=
 he
> wrote that he had configured a RAID in the BIOS; to use that under
> Linux, one needs the dmraid tool to set up BIOS RAID arrays as
> device-mapper devices.  Of course, it is possible that at least one o=
f
> the many (five? six?) Adaptec 94xx driver variants supports both SATA
> and HostRAID natively.
>=20
> Better to use a nice 3ware card that takes care of all this in hardwa=
re.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
