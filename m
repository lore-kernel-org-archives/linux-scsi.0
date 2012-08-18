From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 1/2]block: handle merged discard request
Date: Fri, 17 Aug 2012 23:47:13 -0400
Message-ID: <yq1wr0weu9q.fsf@sermon.lab.mkp.net>
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
	<CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
	<4F69C62C.7020604@kernel.org> <yq18vitwejt.fsf@sermon.lab.mkp.net>
	<CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
	<yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
	<20120620085724.GA26295@infradead.org>
	<yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
	<CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43752 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab2HRDre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Aug 2012 23:47:34 -0400
In-Reply-To: <CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
	(Mike Snitzer's message of "Fri, 17 Aug 2012 23:06:16 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Could be I've wasted a few hours by rebasing these patches...
Mike> regardless, it would be great if you could share what your plans
Mike> are.

Heh, I worked on syncing my patch queue up to Jens' and James' trees
this afternoon. But I didn't quite finish the block stuff, mainly due to
some conflicts with a few topology changes I also have pending.

I'll take a look at your series. Maybe I'll swap things around and put
the topology changes on top instead of below. Leverage some of the work
you did...

-- 
Martin K. Petersen	Oracle Linux Engineering
