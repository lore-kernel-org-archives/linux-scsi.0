From: =?ISO-8859-1?Q?Miroslav_Zaj=EDc?= <Zajsoft@Zajsoft.NET>
Subject: Re: [Bug 5808] aic7xxx - half speed/frequency
Date: Fri, 06 Jan 2006 20:45:58 +0100
Message-ID: <43BEC8F6.5000003@Zajsoft.NET>
References: <200601041758.k04Hw8Sf015281@fire-2.osdl.org>	 <43BD2EED.3060404@Zajsoft.NET> <1136565792.3528.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andrea.zajsoft.net ([81.31.22.74]:58778 "HELO
	andrea.zajsoft.net") by vger.kernel.org with SMTP id S1752499AbWAFTqU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2006 14:46:20 -0500
In-Reply-To: <1136565792.3528.31.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: bugme-daemon@bugzilla.kernel.org, Zajsoft2@Zajsoft.NET, linux-scsi@vger.kernel.org

James Bottomley napsal(a):

>On Thu, 2006-01-05 at 15:36 +0100, Miroslav Zaj=EDc wrote:
> =20
>
>>The please try say me some sysfs settings.
>>   =20
>>
>
>OK, I think your sda is target0:0:0
>
>so
>
>cat /sys/class/spi_transport/target0:0:0/period
>
>I think that will say 100
>
>then echo 50 to the same file and try running an fdisk command to forc=
e
>a renegotiation and see what's in the file.  If it still comes back as
>100 then the problem is in the driver.  If not, it's some generic DV
>issue.
>
>Thanks,
>
>James
>
>
> =20
>
I try u suggestion, but not success.
echo 50 > /sys/class/spi_transport/target0:0:0/period
This dont change content and is still on 100.

Next conception please ;o)
Thanks you for work on my problem....

  Zajsoft
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
