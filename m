From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Wed, 7 May 2003 17:41:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507174152.A31719@infradead.org>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505093833.A13506@infradead.org> <20030505094818.GH8416@beaverton.ibm.com> <20030505111735.A16914@infradead.org> <20030506010521.GB3852@beaverton.ibm.com> <20030507164427.A28899@infradead.org> <20030507161546.GA3368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:45069 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264038AbTEGQ3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 12:29:18 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 19DRzM-0008Fm-00
	for linux-scsi@vger.kernel.org; Wed, 07 May 2003 17:41:52 +0100
Content-Disposition: inline
In-Reply-To: <20030507161546.GA3368@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, May 07, 2003 at 09:15:46AM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, May 07, 2003 at 09:15:46AM -0700, Mike Anderson wrote:
> No I did not read that you where disagreeing I was just indicating that
> I was not calling any sysfs functions from scsi_register do that the
> Scsi_Host's struct device and struct class where not initialized until
> scsi_add_host.
> 
> After reading you mail the other day I believe a better model would be
> to split the device_register using the device_initialize and device_add
> functions. This will mean that after the return of scsi_register
> (scsi_alloc_host) that refcount will be 1 and the Scsi_Host struct is
> ready to be used.

That actually sounds like a good idea.
