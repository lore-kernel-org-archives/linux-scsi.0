From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
Date: Fri, 3 Sep 2004 08:44:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409030844.41174.bjorn.helgaas@hp.com>
References: <200409021719.15267.bjorn.helgaas@hp.com> <1094168177.2097.154.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel8.hp.com ([156.153.255.206]:27024 "EHLO atlrel8.hp.com")
	by vger.kernel.org with ESMTP id S268989AbUICOor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2004 10:44:47 -0400
In-Reply-To: <1094168177.2097.154.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thursday 02 September 2004 5:36 pm, James Bottomley wrote:
> On Thu, 2004-09-02 at 19:19, Bjorn Helgaas wrote:
> > Not being a real SCSI person, I'm sure there's some clever way I'm
> > supposed to figure out which disk is /dev/sda. =A0But sometimes it'=
s
> > not clear from the kernel boot messages, particularly for drivers
> > that don't print the PCI address of the adapter.
>=20
> You do it like this:
>=20
> jejb@gsyprf11> ls -l /sys/block/sda/device
> lrwxrwxrwx =A01 root root 0 Aug 22 10:57 /sys/block/sda/device ->
> ../../devices/parisc0/parisc0:0/pci0000:00/0000:00:01.1/host1/1:0:15:=
0/

Thanks, I knew there must be a cool way.  That doesn't help if you're
trying to figure out the correct "root=3D" to boot your box, of course.=
=2E.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
