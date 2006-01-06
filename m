From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 5808] aic7xxx - half speed/frequency
Date: Fri, 06 Jan 2006 10:43:12 -0600
Message-ID: <1136565792.3528.31.camel@mulgrave>
References: <200601041758.k04Hw8Sf015281@fire-2.osdl.org>
	 <43BD2EED.3060404@Zajsoft.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:4508 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752445AbWAFQnc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2006 11:43:32 -0500
In-Reply-To: <43BD2EED.3060404@Zajsoft.NET>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miroslav =?ISO-8859-1?Q?Zaj=EDc?= <Zajsoft@Zajsoft.NET>
Cc: bugme-daemon@bugzilla.kernel.org, Zajsoft2@Zajsoft.NET, linux-scsi@vger.kernel.org

On Thu, 2006-01-05 at 15:36 +0100, Miroslav Zaj=EDc wrote:
> The please try say me some sysfs settings.

OK, I think your sda is target0:0:0

so

cat /sys/class/spi_transport/target0:0:0/period

I think that will say 100

then echo 50 to the same file and try running an fdisk command to force
a renegotiation and see what's in the file.  If it still comes back as
100 then the problem is in the driver.  If not, it's some generic DV
issue.

Thanks,

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
