From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2/4] scsi: expose AN support to user space
Date: Wed, 15 Aug 2007 09:27:31 -0700
Message-ID: <20070815092731.01b19e0e.kristen.c.accardi@intel.com>
References: <20070808190613.616085010@localhost.localdomain>
	<20070808120822.9cf187bb.kristen.c.accardi@intel.com>
	<46C2B59A.6070200@garzik.org>
	<1187186509.3327.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14327 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167AbXHOQap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 12:30:45 -0400
In-Reply-To: <1187186509.3327.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Wed, 15 Aug 2007 09:01:49 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2007-08-15 at 04:13 -0400, Jeff Garzik wrote:
> > Kristen Carlson Accardi wrote:
> > > If a scsi_device supports async notification for media change, then
> > > let user space know this capability exists by creating a new sysfs
> > > entry "media_change_notify", which will be 1 if it is supported, and
> > > 0 if not supported.  Create a routine which allows scsi devices to
> > > send a uevent when media change events occur.
> > > 
> > > Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > 
> > if James is happy with this patch, I'm happy with patch #2 and #3
> 
> Actually, we just got a second potential consumer ... although I'll
> reprod to have the reporter send it to the list.  It's a device that
> needs notice of report luns data changing.  The proposed mechanism looks
> a bit narrow now (too tied to media change).  I'll see if I can propose
> a more generic update.
> 
> James
> 

Too narrow because it's tied to scsi_device?  Obviously it'd be easy
to expand the scsi_device_event enum to include LUNS_DATA_CHANGE or 
something, and even the scsi_device_event_info struct can easily be 
expanded if you need more info attached to the event.  Let me know if 
there's something specific I can help with.

Kristen
