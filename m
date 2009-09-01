From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 01 Sep 2009 19:20:30 +0300
Message-ID: <4A9D49CE.6080600@panasas.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <1251739735.16169.20.camel@ank32.eng.vmware.com> <1251741624.18828.83.camel@mulgrave.site> <1251755593.16169.51.camel@ank32.eng.vmware.com> <1251815012.3864.55.camel@mulgrave.site> <35f686220909010908k24f0164nc09b1158b6841ff3@mail.gmail.com> <20090901161306.GN22870@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:47276
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754996AbZIAQUd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 12:20:33 -0400
In-Reply-To: <20090901161306.GN22870@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alok Kataria <alokkataria1@gmail.com>, James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>, Bhavesh Davda <bhavesh@vmware.com>

On 09/01/2009 07:13 PM, Matthew Wilcox wrote:
> 
> Umm, we do share code between SCSI drivers.  We have the ULDs (sg, sd,
> sr, etc), we have the midlayer, and we have the transport classes (spi,
> iscsi, fc, etc).
> 

This makes a tons of sense. a scsi_transport_paravirt can have lots of common
nubs. I bet administrators would love such common management facility.

Boaz
