From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Thin provisioning update
Date: Tue, 10 Nov 2009 13:58:37 -0500
Message-ID: <yq18weenr4y.fsf@sermon.lab.mkp.net>
References: <1257308740-4729-1-git-send-email-martin.petersen@oracle.com>
	<20091109142051.GC4855@infradead.org>
	<20091109193409.GA26596@infradead.org>
	<yq13a4nos7y.fsf@sermon.lab.mkp.net>
	<20091110131649.GA4516@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:19390 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbZKJS7x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 13:59:53 -0500
In-Reply-To: <20091110131649.GA4516@infradead.org> (Christoph Hellwig's
	message of "Tue, 10 Nov 2009 08:16:49 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk, matthew@wil.cx, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> Ok.  Jens, please queue the patch below.  And then we'll have to see
>> about getting James to rebase and/or postpone the SCSI portion to
>> round #2.

Christoph> Can't we please get both patches in through one tree?
Christoph> Everything else is a bit of a pain to manage.

I'm intimately familiar with said pain.  Pretty much everything I do
touches both block and scsi :/

But James has been pretty good about rebasing scsi-misc on top of Jens'
tree.  That's how we've done all the other tricky merges.

James, what do you think?

-- 
Martin K. Petersen	Oracle Linux Engineering
