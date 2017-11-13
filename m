From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Mon, 13 Nov 2017 02:14:21 -0500
Message-ID: <20171113021421.4f1e7dc1@Vantage.cJ>
References: <20171110151344.10563-1-hdegoede@redhat.com>
        <20171112164234.48b5185c@Vantage.cJ>
        <46d6dde9-e811-9655-96db-a046de521782@246060.ru>
        <20171113011438.458369bf@Vantage.cJ>
        <d09f29a5-295b-d95c-40ac-bba41bee5fc8@246060.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:60330 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751377AbdKMHNL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Nov 2017 02:13:11 -0500
In-Reply-To: <d09f29a5-295b-d95c-40ac-bba41bee5fc8@246060.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Astafyev <1@246060.ru>
Cc: Hans de Goede <hdegoede@redhat.com>, Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 13 Nov 2017 09:16:39 +0300
Andrey Astafyev <1@246060.ru> wrote:

> 13.11.2017 09:14, J=C3=A9r=C3=B4me Carretero =D0=BF=D0=B8=D1=88=D0=B5=D1=
=82:
> > For my devices, adding US_FL_NO_ATA_1X to unusual_uas.h didn't
> > change anything, and while adding US_FL_IGNORE_UAS (using
> > quirks=3D0bc2:ab34:u,0bc2:ab38:u) there are still device resets,
> > but they cause shorter hangs in system activity (~1 second when
> > UAS was more like ~20). =20
>=20
> Maybe you should try like this: quirks=3D0bc2:ab34:ut,0bc2:ab38:ut ?

It looks like "ut" would do the same as "u" alone, as US_FL_NO_ATA_1X
is only used inside uas.ko.
For some reason, first I wanted to go in the .h, and it's only after,
when the trial and error went more intense, that I used the command-line
parameters.

Will follow up later... I hope the drives won't end up costing more
than 12Gb/s SAS drives on an expensive HBA... as they are definitely
not hassle-free so far.
I had gotten the first 8 TB model in 2015 and had issues, but my
simple, background workload (attic/borg) could afford to use a
workaround of throttling writes*.

--=20
J=C3=A9r=C3=B4me

* https://bugzilla.kernel.org/show_bug.cgi?id=3D93581#c129
