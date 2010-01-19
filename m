From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Pv-drivers] [PATCH] PVSCSI: fix signedness warning with newer
 compilers
Date: Tue, 19 Jan 2010 12:23:43 -0600
Message-ID: <1263925423.4398.14.camel@mulgrave.site>
References: <20100119173819.GA28630@dtor-ws.eng.vmware.com>
	 <1263924492.4398.5.camel@mulgrave.site>
	 <1263925144.24149.7.camel@ank32.eng.vmware.com>
	 <201001191020.30437.dtor@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab0ASSXv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2010 13:23:51 -0500
In-Reply-To: <201001191020.30437.dtor@vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Alok Kataria <akataria@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2010-01-19 at 10:20 -0800, Dmitry Torokhov wrote:
> On Tuesday 19 January 2010 10:19:04 am Alok Kataria wrote:
> > On Tue, 2010-01-19 at 10:08 -0800, James Bottomley wrote:
> > > On Tue, 2010-01-19 at 10:04 -0800, Alok Kataria wrote:
> > > > On Tue, 2010-01-19 at 09:38 -0800, Dmitry Torokhov wrote:
> > > > > pvscsi_setup_msix() expects 'irq' argument to be an int but is being
> > > > > passed unsigned int. Unsigned int is more proper type for IRQ number
> > > > > so let's use it. This shuts off a compile warning with recent
> > > > > compilers.
> > > > >
> > > > > Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> > > >
> > > > LGTM.
> > > >
> > > > Signed-off-by: Alok N Kataria <akataria@vmware.com>
> > >
> > > That would be acked-by unless you want to resend the patch to me?  I
> > > don't have an unmangled copy of it, so someone needs to send it to the
> > > scsi list.
> > 
> > Acked-by is fine with me too. If its an hassle to pick these lines after
> > the patch is sent, I am totally fine if you pick the patch without my
> > Acked-by or SOB line, just wanted to acknowledge that the change is fine
> > by me.
> > 
> 
> Hm, I wonder why the original did not make through to linux-scsi/James.
> I will resend from my other address then.

Well, sometimes it's because someone is using a mail tool that breaks
threading ... but I did a subject search, it definitely isn't in my
folder.  Vger has a fairly esoteric spam reduction mechanism based on
regexps ... perhaps you fell foul of that?

James



