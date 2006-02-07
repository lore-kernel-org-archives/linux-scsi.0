From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: cpqfc gone - all compay RA4X00 Array now useless in linux?
Date: Tue, 7 Feb 2006 08:55:29 +0100
Message-ID: <200602070855.34920@bilbo.math.uni-mannheim.de>
References: <Pine.GSO.4.64.0602061840520.24390@filebunker.xip.at> <200602061923.31944@bilbo.math.uni-mannheim.de> <Pine.GSO.4.64.0602061921160.94@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2065921.XZ069Ty0E7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:57055 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S965009AbWBGHzj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 02:55:39 -0500
In-Reply-To: <Pine.GSO.4.64.0602061921160.94@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: linux-scsi@vger.kernel.org

--nextPart2065921.XZ069Ty0E7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 6. Februar 2006 19:38 schrieben Sie:
>Hello Rolf,
>
>>> _only_ one which supported the now very cheap Compaq FiberChannel Array
>>> RA4X00.
>>>
>>> With all other FC HBA's the logical volumes (LUN's) are not visible.
>>> ---snip---
>>> 5. Compaq RA4x00 firmware version 2.54 and later supports SSP (Selective
>>> Storage Presentation), which maps LUNs to a WWN.  If RA4x00 firmware
>>> prior 2.54 (e.g. older controller) is used, or the FC HBA is replaced
>>> (another WWN is used), logical volumes on the RA4x00 will no longer be
>>> visible. ---snap---
>>>
>>> So... there are 3 possibilities:
>>> 1. Repair the cpqfc driver and but it again into linux?
>>
>> The driver is a horrible hack lacking too many of really needed error
>> handling.
>>
>>> 2. Find out, how to get the RA4x00 arrays with othet HBA's running; I
>>> 	searched about 1 week in Google, no way..
>>
>> We're working on it. The RA4x00 do things normal arrays don't or so.
>
>What means, "We're working on it"?

Martin K. Petersen is working on a new driver for the Controller that also=
=20
supports additional cards. I'm playing a bit around with a completely new=20
driver for myself (as I still don't have seen MKP's one) but I have no acce=
ss=20
to any FC equipment beyond my HBA.

>> I'm not
>> yet familiar enough with this to know exactly what is needed to beat this
>> to work again.
>
>The only thing I have found, why the RA4X00 arrays are different:
>http://mail-index.netbsd.org/tech-kern/2005/01/06/0013.html
>---sip---
>Its been years time since I checked the T10/T11 drafts, but as best I
>recall, there's some SCSI level (SCSI-3? The last ANSI level?)  where
>any device claiming that level is required(?) to implement
>REPORT_LUNS.
>
>I've also seen devices just below that level which just won't talk
>happily to an initiator unless the initiator sends them a REPORT_LUNS.
>(The Compaq RA4000 RAID array was infamous for that. IIRC, the Linux
>driver for the recommended Compaq/Aglient controller sent a REPORT
>LUNs from inside the driver, then remapped the native LUNs to 8-bit
>LUNS for upper layers; or something equally distaseful.)
>---snap---
>
>and the work around seems to be hardcoded in the cpqfc driver.
>perhaps its that part of code....

Yes, but that's not the whole story. It also uses other type of disc=20
representation or sort of stuff.

You may find some additional information in thread "Booting from or using a=
=20
Compaq RA4100 Array" beginning on 2005-12-28.

>>> 3. Aeh.. use... 2.4, use... other OS?
>>
>> The 2.4 might work. And I might have some patches for you to make it a b=
it
>> less broken. But don't expect too much from it.
>>
>>> Hope to find a way... and not only kicking a working driver because of
>>> not as nice code and to much stack memory.
>>
>> It was not really working, at least not when I (remotely via IRC) tested
>> it last time (some month ago).
>
>I would like to give it a try.
>What have been the latest parts of code?

Subversion repository can be found on

http://opensource.sf-tec.de/repos/cpqfc

I need to make a branch for the 2.6 code. Patches can be found at=20
http://opensource.sf-tec.de/kernel/

Eike

--nextPart2065921.XZ069Ty0E7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBD6FJ2XKSJPmm5/E4RAs61AJ9pzb2PmShDTr+orUqX+25ZjijvNACfXCCD
rKn+tG3BqbascdtgvhQuC4E=
=1qMY
-----END PGP SIGNATURE-----

--nextPart2065921.XZ069Ty0E7--
