From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH scsi] cxgb4i : Avoid holding mutex in interrupt context
Date: Wed, 01 Oct 2014 07:36:45 -0400
Message-ID: <1412163405.5299.4.camel@jarvis>
References: <1410828258-14692-1-git-send-email-anish@chelsio.com>
	 <20140922144547.GA32651@infradead.org>
	 <525DB349B3FB5444AE057A887CB2A8D88F76D1@nice.asicdesigners.com>
	,<20141001074919.GA14826@infradead.org>
	 <525DB349B3FB5444AE057A887CB2A8D88F78E8@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44527 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbaJALgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 07:36:48 -0400
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D88F78E8@nice.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anish Bhatt <anish@chelsio.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

On Wed, 2014-10-01 at 08:08 +0000, Anish Bhatt wrote:
> James, 
>     This is bugfix  and prevents a "scheduling while atomic" bug that can be
> hit when using an ipv6 address with cxgb4i, and can possibly be seen without
> Chelsio hardware. Could this be cherry picked for 3.17 please ?

Can you describe the bug it's fixing (what are the consequences) and how
often is it seen?

If it's not something everyone hits, it may be better to go via stable,
because the code change is quite large, so validating that nothing else
breaks with it at this stage (a week away from release) is quite
important.

> Christoph,
>    My bad, this is a bugfix for code that was added for 3.17, and I assumed the
> bugfixes would automatically be picked for the next rc. If James doesn't pick 
> this up, I'll send it to stable when appropriate.

You said in your change log:

        Applies on top of core-for-3.18

So the natural assumption would be this is for the merge window queue.

James


