From: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Subject: RE: Large disk drives
Date: Fri, 7 Nov 2014 10:03:51 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9EAE8F@AcuExch.aculab.com>
References: <533357.25557.qm@web100006.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <533357.25557.qm-303aDswoEIZ5hgrKqgaBcEyFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Content-Language: en-US
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Norman Diamond' <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

=46rom: Norman Diamond
=2E..
> By the way, I've seen some USB bridges that lie about whether they
> performed various SAT commands (ATA passthrough), but told the truth
> about performing an ATA IDENTIFY DEVICE through SAT.=A0 So we could a=
ttempt
> ATA passthrough with an IDENTIFY DEVICE command, and if it happens to
> return a sane looking result, we could comparre it to the bridge's ow=
n
> translation of READ_CAPACITY_10 and READ_CAPACITY_16.=A0 If the passt=
hrough
> yielded a sane result and the capacity doesn't match, we know not to
> trust the bridge with 16-byte commands (except if tested, as mentione=
d).
> In such a case, we don't even have to look at the partition table.=A0=
 Of
> course if the ATA passthrough fails or if the result is garbage then
> abandon this test and maybe look at the partition table.
=2E..

Don't count on devices answering ATA IDENTIFY correctly either.
I had some CF cards from one of the main 'labels' that reported
an incorrectly layed out identify response, and 2 others (almost
identical) that locked solid when the request was issued.
We tried to send them back, but they were returned with a nice
shiny new MBR table.

	David



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
