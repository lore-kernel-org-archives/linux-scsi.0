From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/15] block copy: initial XCOPY offload support
Date: Fri, 18 Jul 2014 10:35:04 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407181034001.13630@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1407151534180.14632@file01.intranet.prod.int.rdu2.redhat.com> <53C91B1E.7060703@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762519AbaGROff (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2014 10:35:35 -0400
In-Reply-To: <53C91B1E.7060703@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org



On Fri, 18 Jul 2014, Tomas Henzl wrote:

> > +	if (src_sector + nr_sects < src_sector ||
> > +	    dst_sector + nr_sects < dst_sector)
> > +		return -EINVAL;
> 
> Hi Mikulas,
> this^ is meant as an overflow test or what is the reason?
> Thanks, Tomas

Yes. It is a test for overflow.

Mikulas
