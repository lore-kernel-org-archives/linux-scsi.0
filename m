From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
Date: Fri, 3 Sep 2004 16:49:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040903144940.GA4941@suse.de>
References: <200409021719.15267.bjorn.helgaas@hp.com> <1094168177.2097.154.camel@mulgrave> <200409030844.41174.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34688 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S269032AbUICOu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2004 10:50:29 -0400
Content-Disposition: inline
In-Reply-To: <200409030844.41174.bjorn.helgaas@hp.com>
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

 On Fri, Sep 03, Bjorn Helgaas wrote:

> > jejb@gsyprf11> ls -l /sys/block/sda/device
> > lrwxrwxrwx =C2=A01 root root 0 Aug 22 10:57 /sys/block/sda/device -=
>
> > ../../devices/parisc0/parisc0:0/pci0000:00/0000:00:01.1/host1/1:0:1=
5:0/
>=20
> Thanks, I knew there must be a cool way.  That doesn't help if you're
> trying to figure out the correct "root=3D" to boot your box, of cours=
e...

initrd, udev, done.

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
