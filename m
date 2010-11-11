From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] target: remove dead DF_* flags
Date: Thu, 11 Nov 2010 07:21:59 -0500
Message-ID: <20101111122159.GA22413@infradead.org>
References: <20101111104040.GA21472@infradead.org>
 <20101111104056.GB21472@infradead.org>
 <1289473630.2867.110.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab0KKMWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 07:22:00 -0500
Content-Disposition: inline
In-Reply-To: <1289473630.2867.110.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, Nov 11, 2010 at 03:07:10AM -0800, Nicholas A. Bellinger wrote:
> This is still required by RAMDISK_DR to allow the backend to perform the
> se_task->task_sg[] mapping from the ramdisk provided struct scatterlists
> using se_subsystem_api->allocate_dma()

It's not actually used anywhere at all.  And if you mean fronted instead
of backend above and imply not yet merged - I don't think adding special
cases for the ramdisk driver into frontends is a good idea, as it's not
really a case worth optimizing for.  And even then it's entirely dead
and untested code for now.

