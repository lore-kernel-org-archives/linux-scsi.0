From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 6/18] megaraid_sas : Use Block layer tag support for
 internal command indexing
Date: Tue, 12 May 2015 00:19:36 -0700
Message-ID: <20150512071936.GB16731@infradead.org>
References: <201504231103.t3NB3e1u029800@palmhbs0.lsi.com>
 <20150511091805.GG28820@infradead.org>
 <5e1ce6ee219828a9d0d000be4836f973@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33732 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbELHTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 03:19:37 -0400
Content-Disposition: inline
In-Reply-To: <5e1ce6ee219828a9d0d000be4836f973@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

On Mon, May 11, 2015 at 03:27:19PM +0530, Sumit Saxena wrote:
> Yes, it's not needed. I will remove this printk. If I resend only this
> patch, then subsequent patches will be affected and needs to be recreated.
> If you are Ok, then I can send a patch to remove this printk rebased on
> top of this series.

Sounds fine to me.  With that the series look ok to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
