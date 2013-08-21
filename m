From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] target/qla2xxx: Define NPIV ops in terms of normal
 ops
Date: Tue, 20 Aug 2013 23:30:08 -0700
Message-ID: <20130821063008.GD25506@infradead.org>
References: <1377046807-15860-1-git-send-email-agrover@redhat.com>
 <1377046807-15860-5-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3HUGaI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 02:30:08 -0400
Content-Disposition: inline
In-Reply-To: <1377046807-15860-5-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Aug 20, 2013 at 06:00:06PM -0700, Andy Grover wrote:
> Instead of defining a second target_core_fabric_ops struct, use the
> same one as normal (tcm_qla2xxx_ops) and then fixup the changed methods.
> 
> This should make it a little easier to pick out the npiv differences, and
> also save a little space.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>

Can't say I'm a huge fan of either the old or new way, I'd rather have
the methods contain both the NPIV and non-NPIV code inline.  If that's
what you're preparing for I'm supportive of this, otherwise I don't
really care too much about it.  Looks correct at least..

