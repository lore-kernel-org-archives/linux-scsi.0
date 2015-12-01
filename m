From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Mon, 30 Nov 2015 23:23:15 -0800
Message-ID: <20151201072315.GA12183@infradead.org>
References: <564F9AFF.3050605@sandisk.com>
 <20151124231331.GA25591@infradead.org>
 <5654F169.6070000@sandisk.com>
 <20151125084744.GA16429@infradead.org>
 <5655CCC0.9010107@sandisk.com>
 <yq1610jf0jk.fsf@sermon.lab.mkp.net>
 <565CF57A.4090507@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbbLAHXX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2015 02:23:23 -0500
Content-Disposition: inline
In-Reply-To: <565CF57A.4090507@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, Aaro Koskinen <aaro.koskinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-mm@kvack.org

On Mon, Nov 30, 2015 at 05:18:50PM -0800, Bart Van Assche wrote:
> Since the original patch caused a regression, please proceed with reverting
> the original patch.
> 
> Regarding this patch: is there anyone on the CC-list of this e-mail who can
> review it ?

I'm not too fond of the approach.  I'd much prefer if SCSI would just
release the dev_t later, similar to DM or MD.
