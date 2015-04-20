From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 13/18] megaraid_sas : add endianess conversions
 for all ones
Date: Mon, 20 Apr 2015 09:43:06 -0700
Message-ID: <1429548186.2222.28.camel@HansenPartnership.com>
References: <201504201236.t3KCagKv016670@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35210 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371AbbDTQnH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 12:43:07 -0400
In-Reply-To: <201504201236.t3KCagKv016670@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, kashyap.desai@avagotech.com

On Mon, 2015-04-20 at 18:04 +0530, Sumit.Saxena@avagotech.com wrote:
> Add noop conversions for all ones to make sparse happy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This isn't the right way to resend someone else's patch: it needs a 

From: Christoph Hellwig <hch@lst.de>

At the top and a signed off by you at the bottom (because you're part of
the transmission chain).

James


