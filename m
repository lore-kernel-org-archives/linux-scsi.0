From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/16] gdth: split out eisa probing
Date: Wed, 3 Oct 2007 19:05:23 +0100
Message-ID: <20071003180523.GA9282@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <200710021920.40354.eike-kernel@sf-tec.de> <20071003172737.GA6446@infradead.org> <200710031932.35187.eike-kernel@sf-tec.de> <20071003173856.GA7140@infradead.org> <4703D87B.5080800@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49220 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbXJCSFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 14:05:31 -0400
Content-Disposition: inline
In-Reply-To: <4703D87B.5080800@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Oct 03, 2007 at 01:59:23PM -0400, Jeff Garzik wrote:
> Come on.  The patches were posted for comments, and Rolf commented. 
> Don't give him a hard time for a valid comment.

Sorry, but these comments are utterly useless.  It's not like we're doing
anything related to dma mapping, but just moving some init code around.
If we actually did a major change in how dma mapping is handled the comment
would be apropinquate and a switchover should happen as part of the patch
series. 
