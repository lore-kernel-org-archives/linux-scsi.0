From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] first cut at infrastructure for handling different
	device types in the sas class
Date: Sat, 04 Mar 2006 12:33:56 -0600
Message-ID: <1141497236.9895.2.camel@mulgrave.il.steeleye.com>
References: <1141445103.5397.19.camel@mulgrave.il.steeleye.com>
	 <20060304154706.GA14174@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:19339 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751090AbWCDSeB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 13:34:01 -0500
In-Reply-To: <20060304154706.GA14174@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2006-03-04 at 15:47 +0000, Christoph Hellwig wrote:
> Looks good in general, but we should probably kill the rphy naming.  That was
> my invention when doing the transport class, when I still thought we'd add a
> remote object for every phy in wide links.  We ended up having just a remote
> object only under one of the phys for a wide link so we should probably
> kill this naming invention.  In the end we should probably just have
> a sas_end_device, sas_expander and sas_sata_device (or just sata_device
> if we can share code with libata) and the common subset (sas_device?)
> shouldn't be exposed to userland on it's own.

Yes ... I was going to say eventually that your rphy object is really an
rport object.

I think, additionally, it would be nice to display ports in the
hierarchy.  What I'm thinking of is basically putting phys and ports on
the same level but placing the expanders and rports (rphys) under the
port directory.  Then the phy can have a simple link to the port it's a
member of.

> this should become sas_end_device_alloc, and so on for the other
> functions.

Yes, will do the renaming ... after I spend the day in Chicago.

James


