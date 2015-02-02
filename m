From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Mon, 02 Feb 2015 14:14:33 +0100
Message-ID: <54CF7839.1050009@redhat.com>
References: <1422486056-11591-1-git-send-email-hch@lst.de> <54CABE29.5080909@redhat.com> <20150130010849.GA4794@ad.nay.redhat.com> <54CB52E9.6000302@redhat.com> <20150202125935.GA16046@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbbBBNOt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2015 08:14:49 -0500
In-Reply-To: <20150202125935.GA16046@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Fam Zheng <famz@redhat.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>



On 02/02/2015 13:59, Christoph Hellwig wrote:
> On Fri, Jan 30, 2015 at 10:46:17AM +0100, Paolo Bonzini wrote:
>> > Great, we might want to revert that patch in 3.21.
> Is that fix in any tree yet?  Seems like I missed it for the scsi
> tree at least.  So unless you want it for 3.19/stable we might as well
> ust skip that patch.

Yes, I agree.

Paolo
