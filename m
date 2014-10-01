From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi] cxgb4i : Avoid holding mutex in interrupt context
Date: Wed, 1 Oct 2014 08:08:32 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88F78E8@nice.asicdesigners.com>
References: <1410828258-14692-1-git-send-email-anish@chelsio.com>
 <20140922144547.GA32651@infradead.org>
 <525DB349B3FB5444AE057A887CB2A8D88F76D1@nice.asicdesigners.com>,<20141001074919.GA14826@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:18750
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751047AbaJAII5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 04:08:57 -0400
In-Reply-To: <20141001074919.GA14826@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "JBottomley@parallels.com" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

James, 
    This is bugfix  and prevents a "scheduling while atomic" bug that can be
hit when using an ipv6 address with cxgb4i, and can possibly be seen without
Chelsio hardware. Could this be cherry picked for 3.17 please ?

Christoph,
   My bad, this is a bugfix for code that was added for 3.17, and I assumed the
bugfixes would automatically be picked for the next rc. If James doesn't pick 
this up, I'll send it to stable when appropriate.
-Anish
________________________________________
From: Christoph Hellwig [hch@infradead.org]
Sent: Wednesday, October 01, 2014 12:49 AM
To: Anish Bhatt
Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; JBottomley@parallels.com; Karen Xie; Manoj Malviya
Subject: Re: [PATCH scsi] cxgb4i : Avoid holding mutex in interrupt context

On Wed, Oct 01, 2014 at 05:22:59AM +0000, Anish Bhatt wrote:
> Little late, but I was hoping this would be pushed as part of fixes to 3.17.
> Is it too late for that ?

It's in the drivers-for-3.18 tree as there was no indication you wanted
it for 3.17.  In fact the description said "Applies on top of
core-for-3.18".  You can try to persuade James to cherry pick if for
3.17, but given how late we are in the cycle that might need very good
argument.  You can always send it to stable@vger.kernel.org as soon as
Linus pulls the SCSI update for 3.18, though.

