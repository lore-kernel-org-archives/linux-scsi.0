From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Mon, 2 Jun 2014 19:22:07 +0000
Message-ID: <1401736926.12939.13.camel@dabdike.int.hansenpartnership.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
	 <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
	 <536AB13E.6080906@cs.wisc.edu>
	 <0eb11761-3b46-44d0-b35a-16d121fe1df4@CMEXHTCAS2.ad.emulex.com>
	 <20140602064601.GA6630@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:51185 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaFBTWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 15:22:19 -0400
In-Reply-To: <20140602064601.GA6630@infradead.org>
Content-Language: en-US
Content-ID: <E617C951D9587E4390EEA9934044506E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "MinhDuc.Tran@Emulex.Com" <MinhDuc.Tran@Emulex.Com>, "jayamohank@gmail.com" <jayamohank@gmail.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Sony.John-N@Emulex.Com" <Sony.John-N@Emulex.Com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@Emulex.Com>

On Sun, 2014-06-01 at 23:46 -0700, Christoph Hellwig wrote:
> I will pull out that patch from the drivers queue, thanks.

Actually, can you really pull it out, not just revert it?  Reverts cause
problems with bisection and are unnecessary before the tree goes to
Linus.

If preserving history becomes a real goal, we'd have to move to a tip
like model, but I'm happy coping with the rebase that dropping a patch
from a monolithic tree causes.

James

