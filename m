From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] scsi_lib: removes ambiguous "Unhandled error code"
 messages.
Date: Thu, 3 Jul 2014 01:41:08 -0700
Message-ID: <20140703084108.GA4296@infradead.org>
References: <1402042235-7246-1-git-send-email-mlombard@redhat.com>
 <20140625110632.GE19181@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B4C8CD@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaGCIlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 04:41:11 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B4C8CD@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jun 25, 2014 at 08:38:47PM +0000, Elliott, Robert (Server Storage) wrote:
> Since the ACTION_FAIL case always prints the sense key
> and additional sense code:

> perhaps the description string should be removed altogether?

> For the "Unhandled error code" (for which you are proposing
> removing the string) and the timeout case, the scsi_print_result 
> call already prints hostbyte and driverbyte, which explain what 
> happened in more detail:

I'm tempted to agree and just remove the description.  Do you want to
send a patch for this?
