From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] libsas: remove task_collector mode
Date: Mon, 24 Nov 2014 09:54:40 +0100
Message-ID: <20141124085440.GA19283@lst.de>
References: <1416818502-19584-1-git-send-email-hch@lst.de> <5472F19D.3070600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35535 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaKXIyn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 03:54:43 -0500
Content-Disposition: inline
In-Reply-To: <5472F19D.3070600@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Chen Gang <gang.chen.5i5j@gmail.com>, Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@Parallels.com>

> Why did you not remove the last argument from asd_can_queue() and
> asd_can_dequeue(), too?
> With that patch it's always '1' ...

Because I wanted to remove the libsas (mis-)feature and avoid to many boad
driver changes.  Especially for a unmaintained big driver like aic94xx.

> This 'while' loop can go, too.

Same here.  Note that this driver never even allowed task collector mode,
so it was already dead code.
