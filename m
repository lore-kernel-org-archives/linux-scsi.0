From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH: Further aacraid work
Date: Wed, 16 Jun 2004 22:33:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616213343.GA20488@infradead.org>
References: <20040616210455.GA13385@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:23456 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266311AbUFPVdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 17:33:45 -0400
Content-Disposition: inline
In-Reply-To: <20040616210455.GA13385@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jun 16, 2004 at 05:04:55PM -0400, Alan Cox wrote:
> I've been going through Mark's changes with a fine toothcomb and this merges
> most of them. Its tested on 64bit SMP hardware and seems to be fine. There
> are a couple of Mark's changes I've left out for now but there isnt really
> an easy way to break down the changes further.
> 
> This fixes a whole host of problems including random hangs under high load

Looks mostly good except for the GART iommu ifdef.  That code is bogus for
almost everything but a plain PC and should just be killed.

Does this apply ontop of Marc's ioctl patch?
