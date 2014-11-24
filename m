From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ARCMSR - Notify sense data report - Lost patch?
Date: Mon, 24 Nov 2014 05:23:31 -0800
Message-ID: <20141124132331.GA4179@infradead.org>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C1FC8@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaKXNXg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 08:23:36 -0500
Content-Disposition: inline
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C1FC8@EXCHANGE.collogia.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "ching2048@areca.com.tw" <ching2048@areca.com.tw>, "thenzl@redhat.com" <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Nov 24, 2014 at 11:47:02AM +0000, Markus Stockhausen wrote:
> Hi,
> 
> sorting out some diffs between the official Arcea driver and 
> the newest 3.18 patches I found a patch that might got lost:
> 
> https://lkml.org/lkml/2014/2/20/956
> 
> Could you check if that is desired?

Looks sensible to me.  Did you test it?

