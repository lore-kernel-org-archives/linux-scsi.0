From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Wed, 3 Oct 2007 09:05:59 +0100
Message-ID: <20071003080559.GA10081@infradead.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432770-git-send-email-matthew@wil.cx> <4702F7B2.7080600@garzik.org> <20071003021545.GD12049@parisc-linux.org> <4702FE4D.4030603@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39067 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbXJCIGP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 04:06:15 -0400
Content-Disposition: inline
In-Reply-To: <4702FE4D.4030603@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Tue, Oct 02, 2007 at 10:28:29PM -0400, Jeff Garzik wrote:
> Incorrect.  That is highly platform specific, with many using unsigned 
> long, since the [non-x86] platform is generally pointing to a special 
> memory region rather than directly using an x86-like instruction.

For port I/O we _do_ use int everywhere.

