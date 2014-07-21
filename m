From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Mon, 21 Jul 2014 04:27:04 -0700
Message-ID: <20140721112704.GA15455@infradead.org>
References: <1405913622-14266-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaGUL1H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2014 07:27:07 -0400
Content-Disposition: inline
In-Reply-To: <1405913622-14266-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com, jasowang@redhat.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Sun, Jul 20, 2014 at 08:33:42PM -0700, K. Y. Srinivasan wrote:
> Add blist flags to permit the reading of the VPD pages even when
> the target may claim SPC-2 compliance. MSFT targets currently
> claim SPC-2 compliance while they implement post SPC-2 features.
> With this patch we can correctly handle WRITE_SAME_16 issues.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

This looks way to complicated - should be a single line added to your
slave_configure function, maybe plus a comment stating what you do
in your commit message:


	sdev->sdev_bflags |= BLIST_TRY_VPD_PAGES;

