From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] Have qla2xxx driver bind fcports.
Date: Mon, 19 Jan 2004 22:00:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119220023.A6725@infradead.org>
References: <1074532278.1645.24.camel@mulgrave> <20040119214030.78010.qmail@web10408.mail.yahoo.com> <20040119134944.515440b0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:18959 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263435AbUASWA3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 17:00:29 -0500
Content-Disposition: inline
In-Reply-To: <20040119134944.515440b0.akpm@osdl.org>; from akpm@osdl.org on Mon, Jan 19, 2004 at 01:49:44PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Michael W. Shaffer" <mwshaffer@yahoo.com>, James.Bottomley@steeleye.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Mon, Jan 19, 2004 at 01:49:44PM -0800, Andrew Morton wrote:
> James is suggesting 2.6.3-pre for merging this patch.  That may be
> conservative: we've only just started in on the post-2.6.1 work, so 2.6.2
> is a while off yet.

My understanding is that this small fix should get in ASAP, but the larger
update from qlogic still needs to settle a bit.  Delaying the fix wouldn't
make any sense to me.

