From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv1] mpt2sas: setpci reset kernel oops fix
Date: Fri, 3 Jul 2015 09:16:25 -0700
Message-ID: <20150703161625.GC32744@infradead.org>
References: <20150625105422.GB21844@nagalsi.ban.indi.seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbbGCQQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 12:16:26 -0400
Content-Disposition: inline
In-Reply-To: <20150625105422.GB21844@nagalsi.ban.indi.seagate.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, jthumshirn@suse.de

On Thu, Jun 25, 2015 at 04:24:22PM +0530, Nagarajkumar Narayanan wrote:
> This patch contains the fix for kernel oops on issuing setpci reset
> along with sysfs, cli access
> 
> spinlock initialization modified to DEFINE_SPINLOCK as per the
> comments for previous version of the patch

Why is the pci_access_mutex usage dependent on is_warpdrive?

Also please send the patch description in the main mail body and the
version updates under the --- liner or in the [0/n] introduction patch.

