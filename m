From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/9] dm-mpath: don't call scsi_dh_attach when we want
	to retain the attached handler
Date: Fri, 1 May 2015 18:46:24 +0200
Message-ID: <20150501164624.GA16490@lst.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de> <1430415151-30948-4-git-send-email-hch@lst.de> <yq1fv7guxa6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55968 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbbEAQq0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 May 2015 12:46:26 -0400
Content-Disposition: inline
In-Reply-To: <yq1fv7guxa6.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

On Fri, May 01, 2015 at 11:34:25AM -0400, Martin K. Petersen wrote:
> +	} else if (m->hw_handler_name) {
>  		/*
>  		 * Increments scsi_dh reference, even when using an
>  		 * already-attached handler.
> 
> Shouldn't this comment be updated to reflect your previous patch?

Yes, it should.  I'll fix it for the resend.
