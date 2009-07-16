From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 15:38:28 +0100
Message-ID: <20090716143828.GB13924@srcf.ucam.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <4A5F3975.70503@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A5F3975.70503@s5r6.in-berlin.de>
Sender: linux-ide-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 16, 2009 at 04:30:13PM +0200, Stefan Richter wrote:
> Matthew Garrett wrote:
> > @@ -447,6 +448,11 @@ struct scsi_host_template {
> >  	unsigned ordered_tag:1;
> >  
> >  	/*
> > +	 * True if host supports hotplugging
> > +	 */
> > +	unsigned hotpluggable:1;
> > +
> 
> The comment should specify what the actual effects of the flag are.
> 
> (Provides the default for Scsi_Host.hotpluggable?)

Ok.

> >  
> > +	/* 1 if hotpluggable, 0 if not */
> > +	unsigned hotpluggable:1;
> > +
> 
> Ditto here.

There's no in-kernel effect of this flag - it's just exposed to 
userspace.

> (Is used by power management infrastructure to decide over runtime PM
> policy?  I.e. don't enter power states which would prevent the port from
> detecting/ reporting hotplug events?)

Exactly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
