From: Tim Pepper <tpepper@vato.org>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Thu, 7 Aug 2003 16:54:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807165452.A27532@jose.vato.org>
References: <1060042082.1985.53.camel@fuzzy> <20030807172028.A13400@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-64-142-13-48.sonic.net ([64.142.13.48]:58378 "HELO
	jose.vato.org") by vger.kernel.org with SMTP id S271103AbTHGXys
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 19:54:48 -0400
Content-Disposition: inline
In-Reply-To: <20030807172028.A13400@infradead.org>; from hch@infradead.org on Thu, Aug 07, 2003 at 05:20:28PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu 07 Aug at 17:20:28 +0100 hch@infradead.org done said:
> > 
> > 5. Vendor value add for specific devices could be encoded both as
> > configuration (udev) pieces and plug-ins to the upper layer multi-path
> > driver to activate any proprietary vendor specific configuration options
> > that may be needed for specific solutions.
> 
> What are examples of such value add?

Personally I'm skeptical that there is much need for plugins, but my employer
really wants to find ways to sell software licenses for advanced
features with their hardware.  They've never defined any advanced features
in terms that weren't marketing speak.  :|

One thing I'm curious about is where non-active-active targets would
be manually failed over to their alternate controller (if they aren't
able to automatically)?  Depending on how config happens, a pluggable
interface for path selection (or error recovery path selection) _and_
configuration may be needed to handle controller failover in the right
way for these devices.  Hopefully this sort of device is going away
though as higher end storage features are commoditised.

At config time there's obviously a need for vendor specific bits since
everybody's doing their inquiry data differently and there's no standard
way to know a device is active-active or if not which is the preferred
controller for a given lun and whether the device is doing automatic
or manual volume transfer on a controller failure.  I for one wouldn't
want to try maintaining a central list of this stuff if the vendors are
willing to do it individually.


t.

-- 
*********************************************************
*  tpepper@vato dot org             * Venimus, Vidimus, *
*  http://www.vato.org/~tpepper     * Dolavimus         *
*********************************************************
