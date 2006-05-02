From: Jeff Garzik <jeff@garzik.org>
Subject: Re: request to add aic94xx to -mm
Date: Tue, 02 May 2006 11:07:18 -0400
Message-ID: <445775A6.2070302@garzik.org>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com> <20060428174623.GA17119@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:27109 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S964869AbWEBPH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2006 11:07:29 -0400
In-Reply-To: <20060428174623.GA17119@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> There's also various issues around the sas code which aic94xx needs:
[snip]

Agree with most of these.  I think these would be best done in tree, 
rather than delaying the driver another year :)


> more comments on the actual aic94xx driver:
[snip

Agree with most of these.  Except for the debugging helper comment, IMO 
these should be handled pre-merge, while it's in -mm.

James, what is the canonical aic94xx home now?

	Jeff



