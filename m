From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
Date: Mon, 13 Aug 2007 13:39:45 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12B85@otce2k301.adaptec.com>
References: <1187025608.10249.141.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:47889 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032577AbXHMRjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2007 13:39:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1187025608.10249.141.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

Please do not collapse AACRAID with DPT_I2O and IPS yet. IMHO Just
because today the maintainer email is the same is not a reason to
collapse, I am only 'paid' to look after aacraid and that one is
provided continued Adaptec support, the others are legacy and
maintenance-only.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com] 
> Sent: Monday, August 13, 2007 1:20 PM
> To: Salyzyn, Mark
> Cc: torvalds@linux-foundation.org; 
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; 
> akpm@linux-foundation.org
> Subject: RE: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
> 
> 
> On Mon, 2007-08-13 at 10:16 -0400, Salyzyn, Mark wrote:
> > Second thoughts ... Add the documentation file as well.
> > +F:	Documentation/scsi/aacraid.txt
> 
> AACRAID SCSI RAID DRIVER
> P:	Adaptec OEM Raid Solutions
> M:	aacraid@adaptec.com
> L:	linux-scsi@vger.kernel.org
> W:	http://www.adaptec.com/
> S:	Supported
> F:	Documentation/scsi/aacraid.txt
> F:	drivers/scsi/aacraid/
> 
> Maybe all 3 entries should be collapsed into
> 
> ADAPTEC SCSI RAID (AACRAID, DPT_I2O, IPS)?
> P:	Adaptec OEM Raid Solutions
> M:	aacraid@adaptec.com
> L:	linux-scsi@vger.kernel.org
> W:	http://www.adaptec.com/
> S:	Supported
> F:	Documentation/scsi/aacraid.txt
> F:	drivers/scsi/aacraid/
> 
> 
> 
