From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add sysfs attributes to scan and delete scsi_devices
Date: Sun, 13 Jul 2003 14:43:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030713144319.A24927@infradead.org>
References: <20030708134016.A32161@beaverton.ibm.com> <1057697416.1825.10.camel@mulgrave> <20030708221350.A19804@infradead.org> <20030708152440.A373@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:5136 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267261AbTGMN2f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jul 2003 09:28:35 -0400
Content-Disposition: inline
In-Reply-To: <20030708152440.A373@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Jul 08, 2003 at 03:24:40PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jul 08, 2003 at 03:24:40PM -0700, Patrick Mansfield wrote:
> Scanning makes more sense as a host attribute (or as a target attribute,
> but we don't have a target device today).

So we should have a scan host attribute for that.

> Deletion of a scsi_device makes
> more sense as a /sysfs/bus/scsi (or even scsi_device) attribute that takes
> a bus_id. 

I don't think it makes sense as a /sysfs/bus/scsi attribute.  Having
it as a scsi_device attribute makes lots of sense, I just wonder whether
the non-symmetric interface would confuse users.  Probably not too much
as scannaing a bus an deleting a device isn't really a symmetric interface
anyway.`

