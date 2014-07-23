From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Wed, 23 Jul 2014 07:10:14 -0700
Message-ID: <20140723141014.GA892@infradead.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723100448.GA2540@sucs.org>
 <20140723115128.GB16881@infradead.org>
 <20140723125443.GA16103@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36161 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaGWOKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2014 10:10:18 -0400
Content-Disposition: inline
In-Reply-To: <20140723125443.GA16103@sucs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com, jasowang@redhat.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org

On Wed, Jul 23, 2014 at 01:54:43PM +0100, Sitsofe Wheeler wrote:
> That's good to know (I was worried the device would not be detected as
> supporting discard because it doesn't report lbpme and doesn't declare a
> conformance version (see below)).

Ok, that makes things worse - you might be able to force it through
sysfs, though.

> Is there a tree with all these updates
> in or do they need to be pieced together from this email thread?

I'm picking this up for my scsi-queue tree.  Still need a review
for the patch we're replying to before that one can go in, though.

> Additionally is it worth quirking sd_try_rc16_first on when
> BLIST_TRY_VPD_PAGES is present?

Sounds reasonable to me.
