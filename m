From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: bio_integrity_verify() bug causing READ verify to be silently
 skipped
Date: Tue, 21 Jan 2014 15:53:22 -0800
Message-ID: <1390348402.5567.805.camel@haakon3.risingtidesystems.com>
References: <1387858826.5567.236.camel@haakon3.risingtidesystems.com>
	 <yq1sit4zv23.fsf@sermon.lab.mkp.net>
	 <1389936047.5567.721.camel@haakon3.risingtidesystems.com>
	 <yq1ha92uv73.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39774 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaAUXvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 18:51:15 -0500
In-Reply-To: <yq1ha92uv73.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, kmo@daterainc.com

On Fri, 2014-01-17 at 16:58 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> >> That breaks partial completion, though. I'll take a look at Kent's
> >> changes...
> 
> nab> Ping..?  Any updates on a proper bugfix for this..?
> 
> I did put your patch in my queue and have been working on a fix for the
> partial completion case. The latter requires a bit of massaging that
> interferes with other pending changes.
> 
> Given that your patch does address a valid issue I'm OK with Jens
> putting it in as is. I'll build upon it for my changes.
> 

<nod>

Jens, are you going to pick this one up, or shall I include it in the
upcoming target-pending/for-next pull request instead..?

Either way, it needs a CC' to stable for >= v3.10.y.

Thanks,

--nab

