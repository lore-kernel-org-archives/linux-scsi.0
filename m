From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 5808] aic7xxx - half speed/frequency
Date: Fri, 06 Jan 2006 15:46:40 -0600
Message-ID: <1136584000.3528.56.camel@mulgrave>
References: <200601041758.k04Hw8Sf015281@fire-2.osdl.org>
	 <43BD2EED.3060404@Zajsoft.NET> <1136565792.3528.31.camel@mulgrave>
	 <43BEC8F6.5000003@Zajsoft.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25004 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751431AbWAFVrA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2006 16:47:00 -0500
In-Reply-To: <43BEC8F6.5000003@Zajsoft.NET>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miroslav =?ISO-8859-1?Q?Zaj=EDc?= <Zajsoft@Zajsoft.NET>
Cc: bugme-daemon@bugzilla.kernel.org, Zajsoft2@Zajsoft.NET, linux-scsi@vger.kernel.org

On Fri, 2006-01-06 at 20:45 +0100, Miroslav Zaj=EDc wrote:
> I try u suggestion, but not success.
> echo 50 > /sys/class/spi_transport/target0:0:0/period
> This dont change content and is still on 100.

It's not supposed to.  The content reflects the current rate.  Unless
you send an I/O to the device to force a negotiation to occur, it won't
change.

So you need to do

echo 50 > /sys/class/spi_transport/target0:0:0/period

fdisk /dev/sda=20

cat /sys/class/spi_transport/target0:0:0/period

the fdisk will force a partition table read down to the device.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
