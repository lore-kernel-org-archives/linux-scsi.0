From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Thu, 05 Feb 2015 10:43:40 -0800
Message-ID: <1423161820.5848.14.camel@HansenPartnership.com>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net>
	 <CAAzz28jJBpu_Uh7b7qOVWk10dS6Q3Ogm087UEW7H9fiTWWGhQQ@mail.gmail.com>
	 <5B997489-2D5C-4F85-BAB8-317E62F694E5@kolumbus.fi>
	 <995891679.6002631.1423158020737.JavaMail.zimbra@redhat.com>
	 <E267A9CB-6A91-4DD6-9BEE-D0DC6C048B07@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57433 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399AbbBESnm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 13:43:42 -0500
In-Reply-To: <E267A9CB-6A91-4DD6-9BEE-D0DC6C048B07@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "\"Kai =?ISO-8859-1?Q?M=E4kisara?= (Kolumbus)\"" <kai.makisara@kolumbus.fi>
Cc: Laurence Oberman <loberman@redhat.com>, Laurence Oberman <oberman.l@gmail.com>, Shane M Seymour <shane.seymour@hp.com>, linux-scsi@vger.kernel.org, jeffm@suse.com

On Thu, 2015-02-05 at 19:46 +0200, "Kai M=C3=A4kisara (Kolumbus)" wrote=
:
> > On 5.2.2015, at 19.40, Laurence Oberman <loberman@redhat.com> wrote=
:
> > I missed the earlier conversations with James, I will go search for=
 them.
> > Do you mean add them so they are similar to the /proc/diskstats
> >=20
> > cat /proc/diskstats
> > ..
> >   8       0 sda 2258346 152801 291907067 5263795 388817 1518048 150=
13833 4542062 0 4794931 9803495
> >   8       1 sda1 717 102 26154 1179 8 2 80 76 0 1172 1254
> >   8       2 sda2 328 31 2872 1554 0 0 0 0 0 1554 1554
> >   8       3 sda3 2195205 151617 290898283 5203627 355053 1518046 15=
009528 4370598 0 4594137 9571937
> >   8       4 sda4 61921 1050 978350 57218 18 0 4225 34 0 56384 57185
> >  11       0 sr0 0 0 0 0 0 0 0 0 0 0 0
> > ..
> >=20
> Not exactly. I mean the data exported in sysfs, for example:
>=20
> > cat /sys/block/sda/sda1/stat
>   159740     9006  5941506    64461   124724    55907 12772208  35986=
77        0   299875  3663235

The problem is we're going to be attacked by the sysfs one value per
file crowd if we do something like this.  Block gets away with it
because it was grandfathered in.  It's only 12 files ... if there's a
good reason for having the fight with the sysfs people, we can; however=
,
I haven't seen a good reason yet, so I'd rather avoid creating a fuss
over something we're going to lose.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
