From: =?iso-8859-1?Q?Strand_=C5ge?= <aage.strand@imr.no>
Subject: RE: aix79xx driver status
Date: Wed, 21 Sep 2005 13:48:56 +0200
Message-ID: <0D54094F69391A438650C6151B0A33E402132A7E@post2.imr.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.imr.no ([82.134.28.194]:45957 "EHLO ns.imr.no")
	by vger.kernel.org with ESMTP id S1750824AbVIULs5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 07:48:57 -0400
Received: from post2.imr.no ([10.1.2.137])
	by ns.imr.no with esmtp (Exim 4.43)
	id 1EI35s-0008Dv-Vs
	for linux-scsi@vger.kernel.org; Wed, 21 Sep 2005 13:48:56 +0200
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Laas <jens.laas@data.slu.se>
Cc: linux-scsi@vger.kernel.org




>-----Original Message-----
>From: Jens Laas [mailto:jens.laas@data.slu.se]
>Sent: Wed 9/21/2005 12:54 PM
>To: Strand =C5ge
>Cc: linux-scsi@vger.kernel.org
>Subject: Re: aix79xx driver status
>=20
>(05.09.21 kl.11:44) Strand =C5ge skrev f=F6ljande till linux-scsi@vger=
=2Ekernel.org:
>
>>
>> Hi,
>>
>> I'm trying to debug an md RAID problem and was looking into aic79xx=20
>> driver version, and now I'm confused.
>
>> I'm having problems with an md RAID running off an Adaptec 39320A-R =
card=20
>> (14 disks, one hot spare). I'm getting PKT busfree errors at random=20
>> intervals which result in RAID disks going offline - so I'm keen to =
see=20
>> if a driver update may help.
>
>Ill just add that we have seen PKT busfree errors too (which take the =
card=20
>offline) with this driver.
>
>(Adaptec ASC-39320D if I remember correctly).

Hm. "Good" to hear I'm not alone :-)
Have you tried replacing the controller with some other brand?=20

I wonder if this is just an Adaptec related issue or if it relates to p=
roblems with the md driver as well.
Sometimes the PKT bug triggers another bug in the md driver which basic=
ally makes the md driver try to update the superblock 100 times (hard c=
oded value) before failing. I'm running a 2.6.9 kernel, the md bug has =
been fixed in later kernels, according to Neil Brown - IIRC.=20

>Also confused about versions and how they relate.

Yes, the version numbering is a bit confusing. On the linux-scsi mailin=
g list I have seen messages about paches going into the aic7xxx/79xx tr=
ee as late as 2004, but there has been no update to the version numbers=
=2E It would be nice if someone could explain that one for me.

Anyhow, according to another message on this list there was a change in=
 maintainer back i June 2004, where Justin T. Gibbs gave it up to Luben=
 Tuikov, then working for Adaptec. I'll try to see if I can get in touc=
h with him.=20

Cheers,
aage
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
