From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Tue, 17 May 2005 11:38:34 -0500
Message-ID: <1116347914.4989.24.camel@mulgrave>
References: <20050516085832.GA9558@gmail.com>
	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>
	 <1116340465.4989.2.camel@mulgrave>  <20050517155731.GA9590@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42178 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261795AbVEQQix (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 12:38:53 -0400
In-Reply-To: <20050517155731.GA9590@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, dino@in.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-05-17 at 17:57 +0200, Gr=E9goire Favre wrote:
> On this controler I have :
>=20
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: IBM      Model: DDRS-39130D      Rev: DC1B
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 15 Lun: 00
>   Vendor: SEAGATE  Model: ST336706LW       Rev: 0108
>   Type:   Direct-Access                    ANSI SCSI revision: 03

Erm, that doesn't square with the bug report:

>   Vendor: IBM-PSG   Model: ST39103LC     !#  Rev: B227
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[...]
>   Vendor: IBM-PSG   Model: ST39103LC     !#  Rev: B227
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> scsi0:A:1:0: Tagged Queuing enabled.  Depth 32

James

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
