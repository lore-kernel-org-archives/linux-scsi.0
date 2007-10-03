From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/16] gdth: split out eisa probing
Date: Wed, 03 Oct 2007 13:59:23 -0400
Message-ID: <4703D87B.5080800@garzik.org>
References: <46FFFC8C.6080804@panasas.com> <200710021920.40354.eike-kernel@sf-tec.de> <20071003172737.GA6446@infradead.org> <200710031932.35187.eike-kernel@sf-tec.de> <20071003173856.GA7140@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50277 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbXJCR7f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 13:59:35 -0400
In-Reply-To: <20071003173856.GA7140@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Wed, Oct 03, 2007 at 07:32:24PM +0200, Rolf Eike Beer wrote:
>> It's not about passing NULL there. We need to do that. But we should call it 
>> with NULL as argument and not with ha->pdev to make this obvious.
> 
> Feel free to send your cleanup patches once we've finished doing the
> important heavy lifting on gdth.

Come on.  The patches were posted for comments, and Rolf commented. 
Don't give him a hard time for a valid comment.

	Jeff



