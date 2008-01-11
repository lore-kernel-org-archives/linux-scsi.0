From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] megaraid: fix section mismatch
Date: Thu, 10 Jan 2008 20:57:10 -0800
Message-ID: <20080110205710.56a868b6.akpm@linux-foundation.org>
References: <20080110143316.071efbc1.randy.dunlap@oracle.com>
	<20080110161023.91bf7618.akpm@linux-foundation.org>
	<1200026735.5337.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797AbYAKE65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 23:58:57 -0500
In-Reply-To: <1200026735.5337.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, sam@ravnborg.org, Mauro Carvalho Chehab <mchehab@infradead.org>, Ingo Molnar <mingo@elte.hu>

On Thu, 10 Jan 2008 22:45:35 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-01-10 at 16:10 -0800, Andrew Morton wrote:
> > On Thu, 10 Jan 2008 14:33:16 -0800
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Change megaraid_pci_driver_g variable name so that it matches the modpost
> > > whitelist that allows pointers to init text/data.
> > > 
> > > WARNING: vmlinux.o(.data+0x1a8e30): Section mismatch: reference to .init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and 'class_device_attr_megaraid_mbox_app_hndl')
> > > 
> > 
> > All these patches fix references to possibly-discarded sections and hence
> > fix possibly-serious bugs.  So all of them should go into 2.6.24.
> 
> Renaming a variable fixes a serious bug?  It quiets a spurious warning
> from modpost, sure, but I hardly think that's -rc7 material.
> 

Rather than unerringly zooming in on the vanishingly trivial: will you be
merging the advansys and qla2xx bugfixes or would you like me to?
