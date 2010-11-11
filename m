From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Thu, 11 Nov 2010 08:49:51 -0800 (PST)
Message-ID: <892012.17950.qm@web31804.mail.mud.yahoo.com>
References: <20101111134450.GB12291@kroah.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:47778 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754510Ab0KKQtx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 11:49:53 -0500
In-Reply-To: <20101111134450.GB12291@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--- On Thu, 11/11/10, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 22, 2010 at 02:12:51PM
> -0700, Luben Tuikov wrote:
> > This patch solves two things:
> > 1) Enables autosense emulation code to correctly
> > interpret descriptor format sense data, and
> > 2) Fixes a bug whereby the autosense emulation
> > code would overwrite descriptor format sense data
> > with SENSE KEY HARDWARE ERROR in fixed format, to
> > incorrectly look like this:
> >=20
> > Oct 21 14:11:07 localhost kernel: sd 7:0:0:0:
> [sdc]=A0 Sense Key : Recovered Error [current]
> [descriptor]
> > Oct 21 14:11:07 localhost kernel: Descriptor sense
> data with sense descriptors (in hex):
> > Oct 21 14:11:07 localhost kernel:=A0 =A0 =A0
> =A0 72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> > Oct 21 14:11:07 localhost kernel:=A0 =A0 =A0
> =A0 00 4f 00 c2 00 50
> > Oct 21 14:11:07 localhost kernel: sd 7:0:0:0:
> [sdc]=A0 ASC=3D0x4 ASCQ=3D0x1d
> >=20
> > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>=20
> I need to get the ack from the usb-storage
> maintainer.=A0 Can you get that
> so that I can apply this?

Hi Greg,

I don't know who the usb-storage maintainer is, as I've mostly contribu=
ted to linux-scsi. Do you? I know Alan acked this patch. Is it him? Any=
 reason you didn't CC the usb-storage maintainer in this email?  Can yo=
u reply back to this thread CC-ing him? The only email I have in my add=
ress book is yours.

Thank you for being so nice and patient in this long, difficult, arduou=
s and intimidating[1] process.

   Luben
[1]linux-2.6/Documentation/development-process/6.Followthrough:22:
"Working with reviewers can be, for many developers, the most intimidat=
ing part of the kernel development process."

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
