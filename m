From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
Date: Mon, 13 Aug 2007 10:16:22 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12AA7@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12A93@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:43254 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946616AbXHMOQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2007 10:16:25 -0400
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12A93@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joe@perches.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

Second thoughts ... Add the documentation file as well.

 F:	drivers/scsi/aacraid/
+F:	Documentation/scsi/aacraid.txt

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Salyzyn, Mark 
> Sent: Monday, August 13, 2007 9:34 AM
> To: 'joe@perches.com'; 'torvalds@linux-foundation.org'; 
> 'linux-scsi@vger.kernel.org'; 'linux-kernel@vger.kernel.org'; 
> 'akpm@linux-foundation.org'; AACRAID
> Subject: RE: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
> 
> ACK
> 
> Sincerely -- Mark Salyzyn
> 
> > -----Original Message-----
> > From: joe@perches.com [mailto:joe@perches.com] 
> > Sent: Monday, August 13, 2007 2:22 AM
> > To: torvalds@linux-foundation.org; 
> > linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; 
> > akpm@linux-foundation.org; AACRAID
> > Subject: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
> > 
> > Add file pattern to MAINTAINER entry
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 7d58f6b..1162fb7 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -241,6 +241,7 @@ M:	aacraid@adaptec.com
> >  L:	linux-scsi@vger.kernel.org
> >  W:	http://www.adaptec.com/
> >  S:	Supported
> > +F:	drivers/scsi/aacraid/
> >  
> >  ACPI
> >  P:	Len Brown
> > 
> 
