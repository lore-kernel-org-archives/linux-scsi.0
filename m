From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 4.8/scsi-queue sligthly outdated
Date: Tue, 21 Jun 2016 23:25:36 -0700
Message-ID: <20160622062536.GB16380@infradead.org>
References: <5768FBC4.5030802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbcFVG0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 02:26:20 -0400
Content-Disposition: inline
In-Reply-To: <5768FBC4.5030802@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jun 21, 2016 at 10:33:08AM +0200, Hannes Reinecke wrote:
> Hi Martin,
> 
> your 4.8/scsi-queue branch sadly is missing the libata zac fixes which
> got pulled into upstream with commit
> e4f7bdc2ec0d0dcc27f7d70db27a620dfdc1f697.
> 
> At the same time, upstream hasn't yet pulled in the request flags split
> from Mike Christie.

The request flags split is only in Jens' for-4.8 tree, so rebasing
on a newer 4.7 release candidate won't help.
