From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: RFC: move hosts.h, scsi.h
Date: Thu, 22 May 2003 23:59:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030522235934.A2006@pclin040.win.tue.nl>
References: <3ECD346D.2070302@pobox.com> <20030522214555.A13150@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:23308 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S261874AbTEVVqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 17:46:31 -0400
Content-Disposition: inline
In-Reply-To: <20030522214555.A13150@infradead.org>; from hch@infradead.org on Thu, May 22, 2003 at 09:45:56PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, May 22, 2003 at 09:45:56PM +0100, Christoph Hellwig wrote:

> Also all this should go into include/scsi/

Long ago include/scsi was created to contain stuff for
inclusion by user space.

But yes, I see that several of these files have been
polluted already with kernel-only stuff.

