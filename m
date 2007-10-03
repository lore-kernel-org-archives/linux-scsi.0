From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/16] gdth: split out eisa probing
Date: Wed, 03 Oct 2007 14:07:22 -0400
Message-ID: <4703DA5A.60009@garzik.org>
References: <46FFFC8C.6080804@panasas.com> <200710021920.40354.eike-kernel@sf-tec.de> <20071003172737.GA6446@infradead.org> <200710031932.35187.eike-kernel@sf-tec.de> <20071003173856.GA7140@infradead.org> <4703D87B.5080800@garzik.org> <20071003180523.GA9282@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58567 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbXJCSHb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 14:07:31 -0400
In-Reply-To: <20071003180523.GA9282@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

Christoph Hellwig wrote:
> On Wed, Oct 03, 2007 at 01:59:23PM -0400, Jeff Garzik wrote:
>> Come on.  The patches were posted for comments, and Rolf commented. 
>> Don't give him a hard time for a valid comment.
> 
> Sorry, but these comments are utterly useless.  It's not like we're doing
> anything related to dma mapping, but just moving some init code around.
> If we actually did a major change in how dma mapping is handled the comment
> would be apropinquate and a switchover should happen as part of the patch
> series. 

A comment noting a useful improvement is always helpful, even if it 
cannot be addressed immediately.  Please don't push reviewers away. 
That severely demotivates other reviewers, when they see such treatment.

We talked about this at the Kernel Summit.

	Jeff



