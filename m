From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 6 Jun 2003 21:52:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606215242.C3240@infradead.org>
References: <1054742495.1674.18.camel@mulgrave> <20030604165146.GA1426@beaverton.ibm.com> <1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org> <3EE0B316.4060207@rogers.com> <20030606202350.GC3330@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:44300 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262269AbTFFUjK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 16:39:10 -0400
Content-Disposition: inline
In-Reply-To: <20030606202350.GC3330@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, Jun 06, 2003 at 01:23:50PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Fri, Jun 06, 2003 at 01:23:50PM -0700, Mike Anderson wrote:
> Instead of talking bit fields it might be good to write down the states
> for scsi_device and Scsi_Host and the policy for each state. This is
> partially being done in this thread, but I believe it is confusing as we
> keep mapping to an already overloaded bit field.

Yes, please, please, please! :)

