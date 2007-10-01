From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 0/16] gdth combined patchset & call for testers
Date: Mon, 01 Oct 2007 16:29:31 +0200
Message-ID: <4701044B.90002@panasas.com>
References: <46FFFC8C.6080804@panasas.com> <470014B5.8050804@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27223 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752322AbXJAOcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2007 10:32:53 -0400
In-Reply-To: <470014B5.8050804@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30 2007 at 23:27 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> BTW, when reposting the patches of others, its nice to add a From: 
> header to the very first line of the email body.  Andrew does that a 
> lot, and the git tools are aware of this convention.
> 
Thanks, yes I was not aware of that at all. Apparently git-am
will make me the author of the patch, but adding a From: like
you said will preserve the original author.
Awaiting comments, I will resend all of these, fixed.

> Also, hey, if you like our patches, I think you should add your own 
> Signed-off-by line (assuming/hoping you reviewed it....).
> 
I wanted to, but I thought only if I change something than I'm
suppose to put the Signed-off-by. But yes I have reviewed all these
patches and am confident in their content. Will fix in next round.

> 	Jeff

Boaz
