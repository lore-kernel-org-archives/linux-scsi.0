From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/7] mpt2sas : Rescan topology from Interrupt context
 instead of work queue
Date: Fri, 14 Aug 2009 14:59:40 +0000
Message-ID: <1250261980.4021.7.camel@mulgrave.site>
References: <20090814094253.GC29415@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbZHNO7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2009 10:59:49 -0400
In-Reply-To: <20090814094253.GC29415@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-08-14 at 15:13 +0530, Kashyap, Desai wrote:
> Following host reset its possible that the controller firmware could
> assign new handles for devices, as well as adding or deleting devices. There is
> code in the driver that will rescan the topology folowing host reset; updating
> device handles, and remove devices that are no longer responding. This patch
> will improve the responsivness by moving this rescaning from the delayed hotplug
> worker thread to immediately following the host reset.
> 
> ---
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> Signed-off-by: Eric Moore <Eric.moore@lsi.com>

For the third time of asking, can you put the signoffs *before* the
three dashes that tell the git importer to ignore the rest of the text
before the patch?

Also, what exactly do these signoffs mean ... they're supposed to track
author and whose hands these patches have been through.  If Eric wrote
them, and you're just submitting them, I need a From: field at the
beginning to change the git authorship (and also the order of signoff
needs reversing).

James


