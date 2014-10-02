From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Thu, 2 Oct 2014 04:36:52 -0700
Message-ID: <20141002113652.GB26897@infradead.org>
References: <1411991272-129962-1-git-send-email-hare@suse.de>
 <542C4D33.2030401@hp.com>
 <20141001211003.GA24820@infradead.org>
 <542CF5E8.3030601@suse.de>
 <20141002091916.GA13227@infradead.org>
 <542D1FF2.1010307@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBLgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 07:36:54 -0400
Content-Disposition: inline
In-Reply-To: <542D1FF2.1010307@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Webb Scales <webbnh@hp.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Thu, Oct 02, 2014 at 11:50:42AM +0200, Hannes Reinecke wrote:
> NCR5380 (and derived LLDDs) and fnic.

fnic needs a tag for a device reset, which we don't provide if it
is issue by ioctl.  This is also showed up during the blk-mq work.
