From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 1/1] cciss: fix PCI IDs for new Smart Array controllers
Date: Mon, 18 Oct 2010 21:14:57 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D0D850CD6@GVW0547EXC.americas.hpqcorp.net>
References: <20101018185307.GA11223@beardog.cce.hp.com>
 <20101018125545.908d97d4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:14000 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0JRVQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2010 17:16:58 -0400
In-Reply-To: <20101018125545.908d97d4.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

 

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Monday, October 18, 2010 2:56 PM
> To: Miller, Mike (OS Dev)
> Cc: Jens Axboe; LKML; LKML-scsi
> Subject: Re: [PATCH 1/1] cciss: fix PCI IDs for new Smart 
> Array controllers
> 
> On Mon, 18 Oct 2010 13:53:07 -0500
> Mike Miller <mike.miller@hp.com> wrote:
> 
> > Patch 1 of 1
> > cciss: fix PCI IDs for new controllers
> > 
> > This patch fixes the botched up PCI IDs of new controllers. Please 
> > consider this patch for inclusion.
> > 
> 
> What was botched up about it?
> 
> What are the runtime effects of this change?
> 
The PCI subsystem ID's were wrong. They were 3250 to 3254. They should have been 335x. I also added another new controller that just popped up.

The runtime effects are the boards will not be recognized without this fix.

-- mikem