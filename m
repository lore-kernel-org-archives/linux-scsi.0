From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/15] target: Pass 2nd param of transport_split_cdb by
 value
Date: Tue, 28 Jun 2011 16:11:52 -0400
Message-ID: <20110628201152.GB9676@infradead.org>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
 <1309289377-8029-3-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55760
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910Ab1F1ULw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 16:11:52 -0400
Content-Disposition: inline
In-Reply-To: <1309289377-8029-3-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 28, 2011 at 12:29:24PM -0700, Andy Grover wrote:
> Since sectors is not modified, it's more straightforward to do this.

Looks fine, although long-term we should really nuke this helper, or
move them into target_core_pscsi.c

