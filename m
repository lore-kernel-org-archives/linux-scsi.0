From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Tue, 17 May 2005 17:14:57 -0500
Message-ID: <1116368097.4989.59.camel@mulgrave>
References: <20050516085832.GA9558@gmail.com>
	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>
	 <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com>
	 <1116354894.4989.42.camel@mulgrave> <20050517192636.GB9121@gmail.com>
	 <1116359432.4989.48.camel@mulgrave> <20050517195650.GC9121@gmail.com>
	 <1116363971.4989.51.camel@mulgrave>  <20050517220948.GF9121@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:23782 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262029AbVEQWPP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 18:15:15 -0400
In-Reply-To: <20050517220948.GF9121@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-05-18 at 00:09 +0200, Gr=E9goire Favre wrote:
> Could I just take some pictures of the boot process and send them to
> you ?

Not really, the messages I need will be embedded in a lot of other
output and will likely scroll off the screen

> Or is there any way to use an usb palm to catch the console output ?

If it has a serial port, sure, just use a serial console.

If it doesn't, try removing the DVD during boot, then plug it back in
again and trigger a device add

echo scsi add-single-device <n> 0 1 0 > /proc/scsi/scsi

where <n> is whatever SCSI number the rest of your CD-ROM's appear on
(it was 1 in your first trace).

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
