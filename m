From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 10/13] scsi: rewrite scsi_request_fn()
Date: Fri, 1 Apr 2005 14:44:34 +0900
Message-ID: <20050401054434.GJ11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.ED6FDDE0@htj.dyndns.org> <20050331111416.GA14857@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.199]:10253 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262641AbVDAFok (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 00:44:40 -0500
Received: by wproxy.gmail.com with SMTP id 68so800850wra
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 21:44:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20050331111416.GA14857@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, Christoph.

On Thu, Mar 31, 2005 at 12:14:16PM +0100, Christoph Hellwig wrote:
> the changes look good to me (although I haven't tested any of your patches
> yet), but the code flow is rather confusing.  What do you think about
> the not even compile version of scsi_request_fn() below that should be
> functionally identical to yours:

 Yes, it's rather confusing.  I was a bit concerned about forward
gotos which are not error handling/exit and possible needs for
unlikely()'s by putting error handling on hotter path, IOW, untaken
forward branch.  For the records, I think the likely/unlikely thingies
are ugly & over-optimization in many cases.

 However, your code is aesthetically much better.  If there are no
opjections regarding the forward non-error-exit jumps, I'll reorganize
the code mostly as you suggested in the next take of this patchset.

 Thanks a lot. :-)

-- 
tejun

