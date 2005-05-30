From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 30 May 2005 10:34:08 -0500
Message-ID: <1117467248.4913.9.camel@mulgrave>
References: <20050517195650.GC9121@gmail.com>
	 <1116363971.4989.51.camel@mulgrave> <20050521232220.GD28654@gmail.com>
	 <1116770040.5002.13.camel@mulgrave> <20050524153930.GA10911@gmail.com>
	 <1117113563.4967.17.camel@mulgrave> <20050526143516.GA9593@gmail.com>
	 <1117118766.4967.22.camel@mulgrave> <20050526173518.GA9132@gmail.com>
	 <1117463938.4913.3.camel@mulgrave>  <20050530150950.GA14351@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:38875 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261557AbVE3PeU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 11:34:20 -0400
In-Reply-To: <20050530150950.GA14351@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-30 at 17:09 +0200, Gr=E9goire Favre wrote:
> uname -r gives me : 2.6.12-rc5 which mean it's a working fix for me !=
!!
>=20
> Note that on the other controller the speed are quiete low ?
> Do you think it's more or less safe to use this kernel so ?

Yes, that was just a global change to get the thing to boot.

Now try this:

echo 100 > /sys/class/spi_transport/target1:0:1/min_period
echo 1 > /sys/class/spi_transport/target1:0:1/revalidate

and look at dmesg to see if it brought the speed up (save your files
first, this may hang the box).

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
