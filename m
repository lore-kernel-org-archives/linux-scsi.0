From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi_lib: replace ambiguous "Unhandled error code"
 messages.
Date: Fri, 6 Jun 2014 09:32:14 +0200
Message-ID: <20140606073214.GA2115@dhcp-27-189.brq.redhat.com>
References: <1401099204-18050-1-git-send-email-mlombard@redhat.com>
 <20140526162506.GB18319@infradead.org>
 <20140526192715.GA2271@dhcp-27-189.brq.redhat.com>
 <20140528110018.GA30751@infradead.org>
 <1401287272.2288.29.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaFFHcm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2014 03:32:42 -0400
Content-Disposition: inline
In-Reply-To: <1401287272.2288.29.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 06:27:52PM +0400, James Bottomley wrote:
> 
> I'm happy with eliminating "Unhanndled Error Code" because that is
> misleading ... we should only get there if we have a DID_X return and
> they're all fatal errors which will be printed.
> 
> I'm less happy removing "Unhandled Sense Code".  The danger is that we
> get some harmless sense code we should have handled and instead error
> the command.  Since for this error we know the next print will be the
> sense code, what about changing it to "Failing Command with sense code:"

It's ok with me,

I'm going to resend the patch in a few minutes.

Thanks,
Maurizio Lombardi

