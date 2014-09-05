From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/19] lpfc 10.4.8000.0: Update lpfc version to driver
 version 10.4.8000.0
Date: Fri, 05 Sep 2014 06:59:01 -0700
Message-ID: <1409925541.2025.8.camel@jarvis.lan>
References: <1409763288.12357.0.camel@myfc17>
	 <20140905053532.GA10457@infradead.org> <5409BB3F.6040205@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51126 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932318AbaIEN7D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 09:59:03 -0400
In-Reply-To: <5409BB3F.6040205@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, 2014-09-05 at 09:31 -0400, James Smart wrote:
> On 9/5/2014 1:35 AM, Christoph Hellwig wrote:
> >   - patches that you send on with your maintainer hat on should be
> >     signed off by you, not just reviewed.
> 
> ok - but I guess I had a different interpretation of the meaning for 
> signed-by.  I thought it conveyed an ownership and originality of 
> authorship of the content posted. As such, if I didn't contribute 
> anything in the patch, I shouldn't give anything other than a 
> reviewed-by indicating approval.

No, this is a DCO thing;the Signed-off-by: tag is the certification
under the DCO:

http://developercertificate.org/

It follows the chain of transmission, whether you alter the patch or
not, so it needs your Signed-off-by for any patch you send on behalf of
another (whether or not you alter it).  By convention, you also append
your alterations to the change log in square brackets, but you don't
have to bother if it's trivial.

James


