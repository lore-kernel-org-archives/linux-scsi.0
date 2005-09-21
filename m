From: Jens Laas <jens.laas@data.slu.se>
Subject: Re: aix79xx driver status
Date: Wed, 21 Sep 2005 12:54:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.63.0509211249100.25666@localhost>
References: <0D54094F69391A438650C6151B0A33E402132A7A@post2.imr.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.slu.se ([130.238.96.11]:41366 "EHLO mail1.slu.se")
	by vger.kernel.org with ESMTP id S1750811AbVIUKym (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 06:54:42 -0400
In-Reply-To: <0D54094F69391A438650C6151B0A33E402132A7A@post2.imr.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Strand_=C5ge?= <aage.strand@imr.no>
Cc: linux-scsi@vger.kernel.org

(05.09.21 kl.11:44) Strand =C5ge skrev f=F6ljande till linux-scsi@vger.=
kernel.org:

>
> Hi,
>
> I'm trying to debug an md RAID problem and was looking into aic79xx=20
> driver version, and now I'm confused.

> I'm having problems with an md RAID running off an Adaptec 39320A-R c=
ard=20
> (14 disks, one hot spare). I'm getting PKT busfree errors at random=20
> intervals which result in RAID disks going offline - so I'm keen to s=
ee=20
> if a driver update may help.

Ill just add that we have seen PKT busfree errors too (which take the c=
ard=20
offline) with this driver.

(Adaptec ASC-39320D if I remember correctly).

Also confused about versions and how they relate.

Cheers,
Jens L=E5=E5s

>
>
> Best regards,
> Aage Strand
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-----------------------------------------------------------------------
     'This mail automatically becomes portable when carried.'
-----------------------------------------------------------------------
     Jens L=E5=E5s                              Email: jens.laas@data.s=
lu.se
     Department of Computer Services, SLU   Phone: +46 18 67 35 15
     Vindbrov=E4gen 1
     P.O. Box 7079
     S-750 07 Uppsala
     SWEDEN
-----------------------------------------------------------------------
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
