From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: thin provisioned LUN support
Date: Thu, 6 Nov 2008 15:24:05 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYKFPYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 10:24:04 -0500
In-Reply-To: <1225984628.4703.80.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

On Thu, 6 Nov 2008, James Bottomley wrote:
> The way to do this properly would be to run a chequerboard of partials,
> but this would effectively have trim region tracking done in the block
> layer ... is this worth it?
>
> By the way, the latest (from 2 days ago) version of the Thin
> Provisioning proposal is here:
>
> http://www.t10.org/ftp/t10/document.08/08-149r4.pdf
>
> I skimmed it but don't see any update implying that trim might be
> ineffective if we align wrongly ... where is this?

I think we should be content to declare such devices 'broken'.

They have to keep track of individual sectors _anyway_, and dropping 
information for small discard requests is just careless.

-- 
dwmw2
