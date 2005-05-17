From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Tue, 17 May 2005 17:57:31 +0200
Message-ID: <20050517155731.GA9590@gmail.com>
References: <20050516085832.GA9558@gmail.com> <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org> <1116340465.4989.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.202]:17764 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261648AbVEQP5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 11:57:34 -0400
Received: by wproxy.gmail.com with SMTP id 69so2035422wra
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2005 08:57:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1116340465.4989.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, dino@in.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, May 17, 2005 at 09:34:25AM -0500, James Bottomley wrote:

> Actually, this isn't a me too.  The previous one looks like some stra=
nge
> DV failure.  This is a problem with the initial inquiry.  What's the
> device at target 15?

On this controler I have :

Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DDRS-39130D      Rev: DC1B
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 15 Lun: 00
  Vendor: SEAGATE  Model: ST336706LW       Rev: 0108
  Type:   Direct-Access                    ANSI SCSI revision: 03

Should I change anything in the BIOS ?

Thank you, and please keep CC to me as I am not on this ml :-)
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
