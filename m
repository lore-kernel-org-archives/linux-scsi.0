From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Suspending SCSI devices and buses
Date: Wed, 18 Aug 2004 21:42:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040818214227.A2616@infradead.org>
References: <Pine.LNX.4.44L0.0408181632410.1138-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:45318 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267650AbUHRUmf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2004 16:42:35 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0408181632410.1138-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Wed, Aug 18, 2004 at 04:36:53PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Aug 18, 2004 at 04:36:53PM -0400, Alan Stern wrote:
> How does a host driver tell the SCSI core that an adapter is being 
> suspended (and hence the core needs to suspend all the devices attached to 
> that adapter)?  Ditto for resume.
> 
> There doesn't appear to be any way to do it.  The scsi_bus_type and 
> various driver structures don't contain a "suspend" entry.

Please read through the "[PATCH] SCSI midlayer power management" thread on
lkml and linux-scsi from last week.

