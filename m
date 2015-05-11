From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: aha152x: Remove residual AHA152X_DEBUG references
Date: Mon, 11 May 2015 02:08:05 -0700
Message-ID: <20150511090805.GB28820@infradead.org>
References: <1430250952-19889-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbEKJIF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:08:05 -0400
Content-Disposition: inline
In-Reply-To: <1430250952-19889-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Apr 28, 2015 at 03:55:52PM -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> Commit f75ae8ed.. ("aha152x: debug output update and whitespace cleanup")
> removed all AHA152X_DEBUG code from aha152x.c, so the build option no longer
> does anything useful.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
