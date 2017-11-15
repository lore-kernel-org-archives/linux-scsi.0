From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: Seagate External SMR drive USB resets... why? / USB storage
 debugging
Date: Wed, 15 Nov 2017 18:27:08 -0500
Message-ID: <20171115182708.25b97ebe@Vantage.cJ>
References: <20171115164902.00d1330d@Vantage.cJ>
        <Pine.LNX.4.44L0.1711151656350.1363-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:52764 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758644AbdKOXZ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Nov 2017 18:25:57 -0500
In-Reply-To: <Pine.LNX.4.44L0.1711151656350.1363-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Jens <jens-bugzilla.kernel.org@spamfreemail.de>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 15 Nov 2017 17:02:39 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > > - It looks like (haven't tested it yet) the CONFIG_DYNAMIC_DEBUG
> > > isn't used with the USB mass storage debugging infrastructure,
> > > please confirm? If unused, are we interested to have a patch that
> > > would go back to regular pr_debug() that can work with dynamic
> > > debugging? =20
>=20
> dev_dbg() please, not pr_debug().  But yes, that would be worthwhile.

Yes obviously.

Adding Joe Perches to the loop as he did a refactor of USB mass storage
a while ago.


> Note, however, that usb-storage debugging is meant only for debugging
> problems in the usb-storage driver itself, not for debugging problems
> in attached devices.  We use usbmon or wireshark for the latter.

OK but I find that a "reset" message without any reason is not
as helpful as it could have been. At the minimum I'll try to scratch my
own itch and see if I can go at the bottom of my issue.


Regards,

--=20
J=C3=A9r=C3=B4me
