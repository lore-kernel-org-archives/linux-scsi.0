From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi] libcxgbi : support ipv6 address host_param
Date: Sun, 19 Oct 2014 17:51:49 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D8921B05@nice.asicdesigners.com>
References: <1413500359-27521-1-git-send-email-anish@chelsio.com>
 <525DB349B3FB5444AE057A887CB2A8D8920F15@nice.asicdesigners.com>
 <20141018151203.GA30355@infradead.org> <20141018151843.GA4262@infradead.org>
 <525DB349B3FB5444AE057A887CB2A8D8921883@nice.asicdesigners.com>,<20141019141740.GB2485@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:21446
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490AbaJSRx1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Oct 2014 13:53:27 -0400
In-Reply-To: <20141019141740.GB2485@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

>> Anything that is an urgent and/or very small fix should just be against
>> Linus' current tree and will go into the drivers branch for that tree.
> 
>> Anything bigger and/or less urgent should be sent against the drivers
>> branch for the next release.

> Linux 3.17 has been released.  The current merge window is the one for
> 3.18, expected to be closed in about a week.  So urgent patches go into
> that, maybe with a Cc to stable@vger.kernel.org if they fix regressions.

I may not have understood you correctly. My understanding is "Linus' current 
 tree and will go into the drivers branch for that tree." would imply 
scsi-queue/drivers-for-3.17.

"drivers branch for next release" would imply be scsi-queue/drivers-for-3.18

So all patches go into drivers-for-3.18, but the ones fixing regressions need a
CC to stable@vger.kernel.org ? Either way, drivers-for-3.18 is fine. Please 
apply there
-Anish
