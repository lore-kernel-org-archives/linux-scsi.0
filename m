From: adam radford <aradford@gmail.com>
Subject: Re: 3ware 9690SA: raid6 array blows up under opensuse 11.2 (2.6.31)
Date: Sun, 13 Dec 2009 12:38:20 -0800
Message-ID: <b1bc6a000912131238y2539a1ccrdd008b79876164da@mail.gmail.com>
References: <4B25036E.7080101@stackingdwarves.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:47950 "HELO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754184AbZLMUiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2009 15:38:21 -0500
Received: by pzk1 with SMTP id 1so1834307pzk.33
        for <linux-scsi@vger.kernel.org>; Sun, 13 Dec 2009 12:38:20 -0800 (PST)
In-Reply-To: <4B25036E.7080101@stackingdwarves.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn_Nettingsmeier?= <nettings@stackingdwarves.net>
Cc: linux-scsi@vger.kernel.org

2009/12/13 J=F6rn Nettingsmeier <nettings@stackingdwarves.net>:
> do you know of any known regressions in the 3ware driver or userspace
> utilities since 2.6.27 (because that was the latest kernel that passe=
d
> the tests) that could be causing this issue?
>

The 3ware driver and userspace utilities do make the decision of whethe=
r
disks get kicked out of the array, the 3ware firmware does.  Make sure
you are running the 9.5.3 (latest) firmware.

> here are some screenshots of the dmesg buffer and the controller bios
> during the error condition:
>
> http://stackingdwarves.net/download/3ware-9690SE-crash/
>

I believe you have bad hardware, or a drive cabling issue.  I will
forward this email
to 3ware support.  They should be able to tell you if you have a known =
flakey
drive firmware rev, enclosure, etc.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
