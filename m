From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: sym2 on sparc
Date: Fri, 8 Oct 2004 04:25:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041008112543.GI9106@holomorphy.com>
References: <20041001182056.GI16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from holomorphy.com ([207.189.100.168]:13526 "EHLO holomorphy.com")
	by vger.kernel.org with ESMTP id S269839AbUJHLZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2004 07:25:57 -0400
Content-Disposition: inline
In-Reply-To: <20041001182056.GI16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-sparc@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Oct 01, 2004 at 07:20:56PM +0100, Matthew Wilcox wrote:
> Could someone with a symbios 53c8xx chip test this patch?  It works
> on non-sparc.  If I don't hear of any problems, it'll be in the next
> driver update.

This looks like it can't go wrong in modern kernels. I suspect the
odd macros are long dead.


-- wli
