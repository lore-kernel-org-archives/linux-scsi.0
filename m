From: =?ISO-8859-1?Q?J=F6rn_Nettingsmeier?=
	<nettings@stackingdwarves.net>
Subject: Re: 3ware 9690SA: raid6 array blows up under opensuse 11.2 (2.6.31)
Date: Sun, 13 Dec 2009 23:24:13 +0100
Message-ID: <4B25698D.5030202@stackingdwarves.net>
References: <4B25036E.7080101@stackingdwarves.net> <b1bc6a000912131238y2539a1ccrdd008b79876164da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.uni-duisburg-essen.de ([132.252.185.20]:41402 "EHLO
	mailout.uni-duisburg-essen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZLMWYQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Dec 2009 17:24:16 -0500
In-Reply-To: <b1bc6a000912131238y2539a1ccrdd008b79876164da@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org

hi adam!


thanks for your reply!

adam radford wrote:
> 2009/12/13 J=F6rn Nettingsmeier <nettings@stackingdwarves.net>:
>> do you know of any known regressions in the 3ware driver or userspac=
e
>> utilities since 2.6.27 (because that was the latest kernel that pass=
ed
>> the tests) that could be causing this issue?
>>
>=20
> The 3ware driver and userspace utilities do make the decision of whet=
her

i guess that should read "do *not*" ?

> disks get kicked out of the array, the 3ware firmware does.  Make sur=
e
> you are running the 9.5.3 (latest) firmware.

i will check this first thing tomorrow and report back.
(the vendor assured me that the firmware was at the latest version, but
i didn't have a chance to check it myself.)

>> here are some screenshots of the dmesg buffer and the controller bio=
s
>> during the error condition:
>>
>> http://stackingdwarves.net/download/3ware-9690SE-crash/
>>
>=20
> I believe you have bad hardware, or a drive cabling issue.=20

as i said before, this issue has occurred with two identical controller
cards, and the vendor claims to also have swapped backplane and cabling=
=2E
i'll try and get their technician on the phone tomorrow to confirm that=
=2E

> I will
> forward this email
> to 3ware support.  They should be able to tell you if you have a know=
n flakey
> drive firmware rev, enclosure, etc.

great, i appreciate your interest and support in this issue!

i'll try and fend off my client for another few days (who is kind of
eager to get the system up and running), but i do want to get this thin=
g
sorted out - i had always been using 3ware gear on linux with great
success...
after spending more than 18 work hours just waiting for the array to
initialize, fall apart, start over, this is getting personal :-D



--=20
J=F6rn Nettingsmeier
Lortzingstr. 11, 45128 Essen, Tel. +49 177 7937487

Meister f=FCr Veranstaltungstechnik (B=FChne/Studio), Elektrofachkraft
Audio and event engineer - Ambisonic surround recordings

http://stackingdwarves.net

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
