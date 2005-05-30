From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 30 May 2005 18:01:48 +0200
Message-ID: <20050530160147.GD14351@gmail.com>
References: <20050521232220.GD28654@gmail.com> <1116770040.5002.13.camel@mulgrave> <20050524153930.GA10911@gmail.com> <1117113563.4967.17.camel@mulgrave> <20050526143516.GA9593@gmail.com> <1117118766.4967.22.camel@mulgrave> <20050526173518.GA9132@gmail.com> <1117463938.4913.3.camel@mulgrave> <20050530150950.GA14351@gmail.com> <1117467248.4913.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.200]:48923 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261629AbVE3QB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 12:01:57 -0400
Received: by wproxy.gmail.com with SMTP id 68so2907289wra
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2005 09:01:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1117467248.4913.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, May 30, 2005 at 10:34:08AM -0500, James Bottomley wrote:

> Yes, that was just a global change to get the thing to boot.

And it works :-)

> Now try this:
>=20
> echo 100 > /sys/class/spi_transport/target1:0:1/min_period
> echo 1 > /sys/class/spi_transport/target1:0:1/revalidate
>=20
> and look at dmesg to see if it brought the speed up (save your files
> first, this may hang the box).

It don't hang my box... and I got this :

 target1:0:1: Beginning Domain Validation
 target1:0:1: Domain Validation skipping write tests
(scsi1:A:1): 10.000MB/s transfers (10.000MHz, offset 15)
 target1:0:1: Ending Domain Validation

Thank,
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
