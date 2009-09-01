From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC][PATCH 5/5] Add pm8001 SAS/SATA HBA driver resend
Date: Tue, 01 Sep 2009 09:41:09 -0500
Message-ID: <1251816069.3864.77.camel@mulgrave.site>
References: <7070AF0E3911400C93DCB795F4E5CE09@usish.com.cn>
	 <20090702021420.GG5480@parisc-linux.org>
	 <C99FE528BF0A4B669B2DE199C3E2D810@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45266 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbZIAOlN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 10:41:13 -0400
In-Reply-To: <C99FE528BF0A4B669B2DE199C3E2D810@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lindar_liu <lindar_liu@usish.com>
Cc: 'Matthew Wilcox' <matthew@wil.cx>, 'jack wang' <jack_wang@usish.com>, linux-scsi@vger.kernel.org, jeff@garzik.org, tom_peng@usish.com

On Thu, 2009-07-02 at 10:30 +0800, lindar_liu wrote:
> Re: [RFC][PATCH 5/5] Add pm8001 SAS/SATA HBA driver resend
> 
> On Thu, Jul 02, 2009 at 09:43:57AM +0800, jack wang wrote:
> > diff --git a/drivers/scsi/pm8001/Kconfig b/drivers/scsi/pm8001/Kconfig
> > new file mode 100644
> > index 0000000..4db6021
> > --- /dev/null
> > +++ b/drivers/scsi/pm8001/Kconfig
> > @@ -0,0 +1,48 @@
> > + config SCSI_PM8001
> > + 	tristate "PMC-Sierra SPC 8001 SAS/SATA Based Host Adapter driver"
> > + 	depends on PCI && SCSI
> > + 	select SCSI_SAS_LIBSAS
> > + 	help
> > +		This driver supports PMC-Sierra PCIE SAS/SATA 8x6G SPC 8001
> > chip
> > +		based host adapters.
> 
> Not really enough here to justify a separate Kconfig file.  How about
> putting this bit in drivers/scsi/Kconfig instead of in its own file?
> [lindar] ok,we will address it when next send.

So is there a "next send" of this driver?

James


