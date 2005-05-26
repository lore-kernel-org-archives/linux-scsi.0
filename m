From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Thu, 26 May 2005 16:35:16 +0200
Message-ID: <20050526143516.GA9593@gmail.com>
References: <20050517170824.GA3931@in.ibm.com> <1116354894.4989.42.camel@mulgrave> <20050517192636.GB9121@gmail.com> <1116359432.4989.48.camel@mulgrave> <20050517195650.GC9121@gmail.com> <1116363971.4989.51.camel@mulgrave> <20050521232220.GD28654@gmail.com> <1116770040.5002.13.camel@mulgrave> <20050524153930.GA10911@gmail.com> <1117113563.4967.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.194]:26175 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261477AbVEZOf2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 10:35:28 -0400
Received: by wproxy.gmail.com with SMTP id 68so350888wri
        for <linux-scsi@vger.kernel.org>; Thu, 26 May 2005 07:35:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1117113563.4967.17.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, May 26, 2005 at 09:19:23AM -0400, James Bottomley wrote:

> Actually, did you capture anything more after this?

No, I have waited some times, and has nothing more were written to my
palm console, I just thought it wouldn't boot further...

> There's an indication from a previous file you sent:
>=20
> Target 1 Negotiation Settings
>         User: 10.000MB/s transfers (10.000MHz, offset 127)
>         Goal: 10.000MB/s transfers (10.000MHz, offset 15)
>         Curr: 10.000MB/s transfers (10.000MHz, offset 15)
>=20
> That for some reason the bus is tied to 10MHz (i.e. fast but not ultr=
a).
> The DV began at Ultra, but it should next drop down to FAST.
>=20
> Also, when it finally boots up what does
>=20
> /sys/class/spi_transport/target1:0:1/min_period
>=20
> contain?

Under 2.6.12-rc2 I haven't this file, what the equivalent ?

Thank you very much for taking care of my problem :-)
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
