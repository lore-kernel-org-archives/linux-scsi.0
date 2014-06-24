From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RESEND] target: Fix a comment in emulate_evpd_86
Date: Tue, 24 Jun 2014 14:28:52 +0200
Message-ID: <20140624122852.GA10036@lst.de>
References: <1403568128-13929-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44474 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbaFXM2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 08:28:53 -0400
Content-Disposition: inline
In-Reply-To: <1403568128-13929-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org

On Mon, Jun 23, 2014 at 05:02:08PM -0700, Andy Grover wrote:
> Fix comment to make it clear that check_dev_wce can return true if
> emulation is in use, but also if it's *not* emulated but the underlying
> device supports it.
> 
> Reviewed-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Andy Grover <agrover@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
