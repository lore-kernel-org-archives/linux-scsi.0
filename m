From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: Re: aacraid adaptec 6805 support?
Date: Fri, 13 May 2011 17:39:22 +0200
Message-ID: <20110513153922.GA5041@apartia.fr>
References: <20110513141242.GA1048@apartia.fr>
 <20110513164922.5167ea53@harpe.intellique.com>
 <20110513145420.GA2797@apartia.fr>
 <20110513172457.0db50c93@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:34715 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1EMPjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2011 11:39:23 -0400
Content-Disposition: inline
In-Reply-To: <20110513172457.0db50c93@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, May 13, 2011 at 05:24:57PM +0200, Emmanuel Florac wrote:
> Le Fri, 13 May 2011 16:54:21 +0200
> Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org> =E9criva=
it:
>=20
> > Ah, but I am trying with 2.6.38.6 and it seems the driver lags behi=
nd
> > kernel sources.
>=20
> It looks like this driver version (1.1-7) will be included in 2.6.39
> though, so it should compile against the most current kernel. Or
> maybe grab the source from the linux-next tree instead ?

Yep, the driver is included - and works - with 2.6.39-rc7.

Now I have another problem: my 8 sata disks used to work with a
LSI-SAS2008 controller in "no-configuration" mode (meaning I configured
no array on that card, just used the disks for sw raid).

Now when I connect these same disks to the Adaptec controller my first
two /dev/mdX (0 and 1) devices work fine but /dev/md2 doesn't:

	May 13 17:14:37 zenon kernel: md: sde3 does not have a valid v1.2 supe=
rblock, no
t importing!

On each disk the third partition /dev/sdX3 is the last and largest but
it seems the Adaptec controller doesn't "see" the end of the disk where
the md superblock is? Does that make sense?

When booting the controller lists all disks in "legacy" mode. What does
that mean vs JBOD?

Thanks,
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
