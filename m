From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] sgbind
Date: Wed, 14 May 2003 07:49:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514074930.A11818@beaverton.ibm.com>
References: <3EC2379C.4010709@torque.net> <20030514140235.A20579@infradead.org> <3EC24C61.4070203@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:18384 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262422AbTENOlt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 10:41:49 -0400
Content-Disposition: inline
In-Reply-To: <3EC24C61.4070203@torque.net>; from dougg@torque.net on Thu, May 15, 2003 at 12:02:09AM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, May 15, 2003 at 12:02:09AM +1000, Douglas Gilbert wrote:

> >>struct sgbind_nexus {
> >>         int descriptor_id;      /* set to 0 for now */
> > 
> > 
> > Why is this signed?
> 
> It is simply a guard, allowing a different toplogical
> representation (perhaps with a 64 bit, multi-level
> lun).
> 
> >>         unsigned int host_no;
> >>         unsigned int channel;
> >>         unsigned int scsi_id;
> >>         unsigned int lun;

Why not use an 8 byte LUN now? You could still keep the descriptor.

-- Patrick Mansfield
