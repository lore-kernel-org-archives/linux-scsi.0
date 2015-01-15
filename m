From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] How SRP initiator performance has been
 improved via scsi-mq
Date: Thu, 15 Jan 2015 01:15:21 -0800
Message-ID: <20150115091521.GA3360@infradead.org>
References: <54B638E3.3030406@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbbAOJPX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2015 04:15:23 -0500
Content-Disposition: inline
In-Reply-To: <54B638E3.3030406@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jan 14, 2015 at 10:37:39AM +0100, Bart Van Assche wrote:
> Recently it has been proposed to discuss how to add scsi-mq support in
> the iSER initiator during the 2015 edition of the LSF/MM summit. In the
> discussion that followed that proposal several questions were asked
> about how scsi-mq support has been added in the SRP initiator driver,
> which design choices have been made and which lessons have been learned.
> Hence the proposal to add a topic to the LSF/MM schedule for reporting
> how scsi-mq support has been added in the SRP initiator.
> 
> For the actual discussion see also Sagi Grimberg, [LSF/MM TOPIC] iSCSI
> MQ adoption via MCS discussion, linux-scsi mailing list, January 7, 2015
> (http://thread.gmane.org/gmane.linux.scsi/98199).
> 
> Christoph and Mike, if you would like to complement this topic with a
> presentation about the scsi-mq core itself and/or integration of
> multiqueue support in the device mapper multipath driver, I would
> welcome this.

A big long blk-mq / scsi-mq sessions sounds like a good plan.  That
can include a brief overview of the existing work and all the
still pending bits for iSCSI/iSER, multipath and so on.
