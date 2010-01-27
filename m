From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: fw: smartd crashing recent 2.6.32 kernel
Date: Tue, 26 Jan 2010 23:22:56 -0500
Message-ID: <4B5FBFA0.2090902@interlog.com>
References: <1114886585@web.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55099 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab0A0EXE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2010 23:23:04 -0500
In-Reply-To: <1114886585@web.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devzero@web.de
Cc: linux-scsi@vger.kernel.org, support@lsi.com, Smartmontools Mailing List <smartmontools-support@lists.sourceforge.net>

devzero@web.de wrote:
> maybe someone has a clue....!?
>=20
> see https://bugzillafiles.novell.org/attachment.cgi?id=3D338427
>=20
> that box seems to crash in megaraid_mbox driver as soon as smartd is =
starting - even with recent 2.6.32 kernel.
>=20
> as this box will go into production between mid/end of february, i th=
ink that is not much time if there is something to fix (and then being =
tested/confirmed to be fixed)

Roland,
Running 'smartd -r ioctl,1' from the command line might
help us find which command it didn't like. That will
send information to the log. If the crash truncates the
log then add '-d' to the above invocation to dump debug
information to the console. Information about the disks
would be useful as well.

Does the megaraid controller have the latest firmware
from LSI?

https://bugzilla.novell.com/show_bug.cgi?id=3D573244

Doug Gilbert


>> -----Urspr=FCngliche Nachricht-----
>> Von: <devzero@web.de>
>> Gesendet: 25.01.10 12:15:09
>> An: smartmontools-support@lists.sourceforge.net
>> Betreff: smartd crashing recent 2.6.32 kernel
>> Hi,=20
>>
>> just wanted to let you know that smartd is crashing my system at lat=
e installation stage.
>>
>> have opened novell bugticket #573244 ( https://bugzilla.novell.com/s=
how_bug.cgi?id=3D573244 ) for this.
>>
>> regards
>> roland

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
