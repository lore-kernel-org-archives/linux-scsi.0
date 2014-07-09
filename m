From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/14] sd: don't use rq->cmd_len before setting it up
Date: Wed, 9 Jul 2014 17:03:42 +0200
Message-ID: <20140709150342.GA25257@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-2-git-send-email-hch@lst.de> <53BD23A2.4030902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53924 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaGIPDr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 11:03:47 -0400
Content-Disposition: inline
In-Reply-To: <53BD23A2.4030902@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

FYI, this has been dropped from the series in favour of always memsetting
the cdb in common code.  Take a look at the "RFC: clean up command setup"
series, on top of which I have rebased the scsi-mq changes.

