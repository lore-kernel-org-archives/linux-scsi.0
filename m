From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/15] copy offload patches
Date: Mon, 14 Dec 2015 20:22:42 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512142018030.8189@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com> <yq1r3iuylwd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbbLOBWo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 20:22:44 -0500
In-Reply-To: <yq1r3iuylwd.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>



On Thu, 10 Dec 2015, Martin K. Petersen wrote:

> >>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> Mikulas,
> 
> Mikulas> This patch series adds copy offload (the XCOPY command) to the
> Mikulas> block layer, SCSI subsystems and device mapper.
> 
> Now that the VFS stuff appears to stabilize I agree it's a good time to
> revisit all this. I just merged the required VPD patches from Hannes so
> those will be in 4.5.
> 
> I have a bunch of changes to the SCSI code that I worked on over the
> spring/summer based on a feedback from the array vendors after
> discussions we started at LSF/MM. Generally speaking, their comments
> didn't make things easier, nor prettier :( But your two bio approach is
> a requirement to accommodate those needs (token-based copy) so I'll work
> on consolidating your changes with mine.

Let me know when you make some progress with that.

Is there some software iSCSI implementation that supports token-based 
copy? So that I could try to make support for it.

Mikulas

> That said, we still need Mike Christie's patches to go in first.
> 
> Mike: What's your status? I'm afraid I didn't get a chance to dig very
> deep in your series since it coincided with me scrambling to sort out
> SCSI for 4.4. Do you think there's a chance we could get your patches in
> shape for 4.5? Is there an up-to-date tree I can look at?
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering

Mikulas
