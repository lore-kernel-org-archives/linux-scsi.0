From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Pv-drivers] [PATCH] PVSCSI: fix signedness warning with newer
 compilers
Date: Tue, 19 Jan 2010 12:08:12 -0600
Message-ID: <1263924492.4398.5.camel@mulgrave.site>
References: <20100119173819.GA28630@dtor-ws.eng.vmware.com>
	 <1263924273.24149.1.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab0ASSIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2010 13:08:21 -0500
In-Reply-To: <1263924273.24149.1.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akataria@vmware.com
Cc: Dmitry Torokhov <dtor@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2010-01-19 at 10:04 -0800, Alok Kataria wrote:
> On Tue, 2010-01-19 at 09:38 -0800, Dmitry Torokhov wrote:
> > pvscsi_setup_msix() expects 'irq' argument to be an int but is being
> > passed unsigned int. Unsigned int is more proper type for IRQ number
> > so let's use it. This shuts off a compile warning with recent
> > compilers.
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> 
> LGTM.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>

That would be acked-by unless you want to resend the patch to me?  I
don't have an unmangled copy of it, so someone needs to send it to the
scsi list.

Thanks,

James


