From: Olaf Hering <olh@suse.de>
Subject: Re: [RFC] exposing the sdev_target in sysfs
Date: Sat, 4 Sep 2004 09:24:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040904072427.GA19656@suse.de>
References: <1094254851.1712.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:5545 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S266838AbUIDHY2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2004 03:24:28 -0400
Content-Disposition: inline
In-Reply-To: <1094254851.1712.28.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

 On Fri, Sep 03, James Bottomley wrote:

> The aim of this patch is to give us somewhere to hang the per target
> timer that emulex needs.
>=20
> However, it will break the current sysfs layout.  devices will now
> appear something like this:
>=20
> lrwxrwxrwx  1 root root 0 Sep  3 18:31
> /sys/class/scsi_device/0:0:5:0/device ->
> ../../../devices/parisc8/parisc8:0/pci0000:00/0000:00:13.0/host0/targ=
et0:0:5/0:0:5:0
>=20
> (note the extra target0:0:5 in there).
>=20
> which may break some of the user land tools (although you're all usin=
g
> the scsi class interface to access your devices, aren't you? in which
> case you won't notice any problems).

I do something like this to get to the controller.
cd /sys/block/sda/device
cd `pwd -P`
cd ../..
But if target* will be a stable interface, its easy to change.

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
