From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH RFC 0/3] SCSI Userspace Target
Date: Wed, 25 Jan 2006 12:46:49 -0500
Message-ID: <20060125174649.GH14225@havoc.gtf.org>
References: <1138157882.11692.31.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:23469 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751033AbWAYRq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 12:46:58 -0500
Content-Disposition: inline
In-Reply-To: <1138157882.11692.31.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2006 at 08:58:02PM -0600, Mike Christie wrote:
> The following patches begin to add the infrastructure for the SCSI
> Userspace target framework. We were not sure about what James meant by
> some of his comments, so rather than getting to far we want to post a
> early.
> 
> As the email subject hints, the goal of the project is to push most of
> the target code to userspace. The only parts we kept in the kernel were
> for transferring data between the LLD and userpsace and the netlink
> interface. We included the relevant parts of a software iscsi target as
> an example.

I'm glad this got posted, I've been wanting something like this for a
while.  My own personal interest is implementing a tSCSI (my answer to
iSCSI) target.

One random comment:  Take a look at the mmap'd ring buffer interface
provided by mmap'ing the packet socket.  That's the ideal async
interface, since that's fully async, very close to hardware reality.

	Jeff


