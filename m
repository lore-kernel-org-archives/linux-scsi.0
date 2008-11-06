From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: thin provisioned LUN support
Date: Thu, 6 Nov 2008 15:57:29 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0811061556560.3431@Nokia-N800-26>
References: <4913028B.6010405@redhat.com> <yq1d4h8nao5.fsf@sermon.lab.mkp.net>
 <4913107C.3040607@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40777 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYKFP5T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 10:57:19 -0500
In-Reply-To: <4913107C.3040607@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

On Thu, 6 Nov 2008, Ric Wheeler wrote:

> Just not sure that we have any way to handle this better than what is in 
> already (best effort, maybe a post/defrag like user util that can be run 
> offline to clean up?)

Well, it will get a _little_ better, because we will fix it so that 
discard requests can at least be merged by the elevators (and stop being 
barriers)

-- 
dwmw2
