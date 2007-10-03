From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/16] gdth: split out eisa probing
Date: Wed, 3 Oct 2007 18:38:56 +0100
Message-ID: <20071003173856.GA7140@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <200710021920.40354.eike-kernel@sf-tec.de> <20071003172737.GA6446@infradead.org> <200710031932.35187.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47286 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbXJCRjO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 13:39:14 -0400
Content-Disposition: inline
In-Reply-To: <200710031932.35187.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Oct 03, 2007 at 07:32:24PM +0200, Rolf Eike Beer wrote:
> It's not about passing NULL there. We need to do that. But we should call it 
> with NULL as argument and not with ha->pdev to make this obvious.

Feel free to send your cleanup patches once we've finished doing the
important heavy lifting on gdth.

