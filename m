From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 27/27] scsi: ratelimit I/O error messages
Date: Tue, 28 Oct 2014 18:36:55 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959345A0D@G9W0745.americas.hpqcorp.net>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
 <1414153627-2863-28-git-send-email-hare@suse.de>
 <94D0CD8314A33A4D9D801C0FE68B4029593375F6@G9W0745.americas.hpqcorp.net>
 <20141028175709.GA8088@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:39888 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaJ1SjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2014 14:39:01 -0400
In-Reply-To: <20141028175709.GA8088@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, 28 October, 2014 12:57 PM
> To: Elliott, Robert (Server Storage)
> Cc: Hannes Reinecke; James Bottomley; Christoph Hellwig; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 27/27] scsi: ratelimit I/O error messages
> 
> On Fri, Oct 24, 2014 at 09:00:15PM +0000, Elliott, Robert (Server
> Storage) wrote:
> > Assuming the MLQUEUE -> MLCOMPLETE fix is put back in,
> > you may add:
> > Tested-by: Robert Elliott <elliott@hp.com>
> > Reviewed-by: Robert Elliott <elliott@hp.com>
> 
> Does this apply just to this patch or the whole series?

I didn't exercise every change in the series, so just
keep the Tested-by tag on this one.

1-24 have Reviewed-by tags (I reviewed v5 which ended there).
25-26 do not; I'll take a look at them now.

