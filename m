From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Thu, 11 Nov 2010 10:27:11 -0800 (PST)
Message-ID: <673670.8195.qm@web31801.mail.mud.yahoo.com>
References: <20101111174322.GB20296@one-eyed-alien.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:47953 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754876Ab0KKS1N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 13:27:13 -0500
In-Reply-To: <20101111174322.GB20296@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--- On Thu, 11/11/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> =
wrote:
> On Thu, Nov 11, 2010 at 09:07:53AM -0800, Luben Tuikov wrote:
> >=20
> > Oh, I see. I'll re-post the patch then to Matthew and
> the people and lists you listed above.
>=20
> Now that I'm on the CC, I see this.
>=20
> What's the 10k-foot level summary here?

I'm not sure either. It's apparently the procedure of getting a patch i=
nto the linux kernel nowadays. Last time I did this was 5 years ago and=
 in linux-scsi--I remember it being easier, again that was 5 years ago.

> Is there an alternate sense-data format that uses some sort of "descr=
iptor" structure?

Yes. Some devices return this format of sense data for some commands.

> I'm assuming this is
> a new SCSI-III thing, or did I just miss it in SCSI-II?
> This *looks* like you're using functions provided by the
> SCSI core to
> access and modify the sense data... so I'm assuming that's
> because there
> are alternate formats...

The patch doesn't add code that modifies the sense data. That modificat=
ion code is already there, the patch fixes the modification which assum=
ed only one type of format of sense data.

The patch uses SCSI functions to abstract the sense information irrespe=
ctive of the type of format of sense data.

>=20
> Matt
>=20
> --=20
> Matthew Dharm=A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 Home: mdharm-usb@one-eyed-alien.net
>=20
> Maintainer, Linux USB Mass Storage Driver
>=20
> It was a new hope.
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 -- Dust Puppy
> User Friendly, 12/25/1998
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
