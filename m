From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Sat, 28 Jun 2003 09:34:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030628093403.A8591@infradead.org>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0306271347250.774-100000@ida.rowland.org> <20030627190434.A10771@infradead.org> <20030627192321.GA3338@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:33810 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265133AbTF1ITu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jun 2003 04:19:50 -0400
Content-Disposition: inline
In-Reply-To: <20030627192321.GA3338@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, Jun 27, 2003 at 12:23:21PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jun 27, 2003 at 12:23:21PM -0700, Mike Anderson wrote:
> I looked over linux-netdev and can not pick out a thread on this
> subject. Could you point to the thread or at least the subject of the
> thread.

It's spread over lots of thread.  Two big relevant threads I could find
easily are:

dev->destructor

and

[PATCH 2.5.70] Add release_netdev -- hook for sysfs/net device cleanup


> I was wanting to see the consensus of the core change.

The folks doing the netdev refocunting changes (davem, viro, jgarzik, sch)
seem to agree on it :)  But IMHO it's the only way to go anyway - every
subsystem with sysfs exposure will need something similar.

> I have a set of patch running right now on top of scsi-misc-2.5
> (1:a:stern_present 2:a:shost_present 3:a:shost_state 4:a:sdev_state)
> that fix some release issues and adds a state attribute to shost and
> sdev. The patch set does still have the show / store issue, but does
> seem to cleanup better post a surprise removal call to scsi_remove_host.

Cool.

