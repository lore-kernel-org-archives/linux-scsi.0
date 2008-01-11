From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] megaraid: fix section mismatch
Date: Thu, 10 Jan 2008 23:34:27 -0600
Message-ID: <1200029667.5337.13.camel@localhost.localdomain>
References: <20080110143316.071efbc1.randy.dunlap@oracle.com>
	 <20080110161023.91bf7618.akpm@linux-foundation.org>
	 <1200026735.5337.3.camel@localhost.localdomain>
	 <20080110205710.56a868b6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40665 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbYAKFef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 00:34:35 -0500
In-Reply-To: <20080110205710.56a868b6.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, sam@ravnborg.org, Mauro Carvalho Chehab <mchehab@infradead.org>, Ingo Molnar <mingo@elte.hu>


On Thu, 2008-01-10 at 20:57 -0800, Andrew Morton wrote:
> On Thu, 10 Jan 2008 22:45:35 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Thu, 2008-01-10 at 16:10 -0800, Andrew Morton wrote:
> > > On Thu, 10 Jan 2008 14:33:16 -0800
> > > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > > 
> > > > Change megaraid_pci_driver_g variable name so that it matches the modpost
> > > > whitelist that allows pointers to init text/data.
> > > > 
> > > > WARNING: vmlinux.o(.data+0x1a8e30): Section mismatch: reference to .init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and 'class_device_attr_megaraid_mbox_app_hndl')
> > > > 
> > > 
> > > All these patches fix references to possibly-discarded sections and hence
> > > fix possibly-serious bugs.  So all of them should go into 2.6.24.
> > 
> > Renaming a variable fixes a serious bug?  It quiets a spurious warning
> > from modpost, sure, but I hardly think that's -rc7 material.
> > 
> 
> Rather than unerringly zooming in on the vanishingly trivial: will you be
> merging the advansys and qla2xx bugfixes or would you like me to?

You can ... looking at the advansys one, the isa driver remove will
always oops without the fix.  The qlogic one is less serious.

James


