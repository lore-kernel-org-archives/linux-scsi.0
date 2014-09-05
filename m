From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 0/19] lpfc 10.4.8000.0: Update lpfc version to driver
 version 10.4.8000.0
Date: Fri, 5 Sep 2014 09:31:43 -0400
Message-ID: <5409BB3F.6040205@emulex.com>
References: <1409763288.12357.0.camel@myfc17> <20140905053532.GA10457@infradead.org>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:9818 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaIENcR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 09:32:17 -0400
In-Reply-To: <20140905053532.GA10457@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

no problem, although if these rules were published, I would have tried 
to do so earlier.

although - I do have a couple of questions.


On 9/5/2014 1:35 AM, Christoph Hellwig wrote:
> I've applied the series, but for next time can you make sure to follow
> the proper format:
>
>   - remove the version number in every subject line

yeah - it's long


>   - patches you resend from an original author should be unchanged,
>     except that the From: lines moves into the mail body

So.. you do not want me to resolve merge conflicts or fuzz before posting ?

note: content did not change - only merged into my git tree and re-cut them.


>   - patches that you send on with your maintainer hat on should be
>     signed off by you, not just reviewed.

ok - but I guess I had a different interpretation of the meaning for 
signed-by.  I thought it conveyed an ownership and originality of 
authorship of the content posted. As such, if I didn't contribute 
anything in the patch, I shouldn't give anything other than a 
reviewed-by indicating approval.


>
> not strictly required, but making my life a lot easier would be if all
> patches are sent by reply to the original mail.  git-send-email does
> this, and it seems like the Emulex division supporting be2scsi has found
> a way to use it with the corporate email servers.

yep - although different countries have different logistics. But, I 
should be able to get around this.

-- james


