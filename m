From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 18:40:54 +0100
Message-ID: <20050710174054.GA28623@infradead.org>
References: <42D133EE.9090204@s5r6.in-berlin.de> <20050710153126.GB14956@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34727 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261986AbVGJRk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:40:59 -0400
Content-Disposition: inline
In-Reply-To: <20050710153126.GB14956@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sun, Jul 10, 2005 at 11:31:26AM -0400, Ben Collins wrote:
> Yeah, seems like every two months we have to change sbp2 to accomodate
> changes to the scsi layers whole reference scheme which never seems
> simple, and never stays the same.

While the implementation has changed a little the exposed interface
never changed at all since before 2.6.0.

