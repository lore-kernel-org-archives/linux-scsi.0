From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 1/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 14:15:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928141547.A1871@infradead.org>
References: <41596126.7080502@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:32531 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267779AbUI1NPx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:15:53 -0400
Content-Disposition: inline
In-Reply-To: <41596126.7080502@adaptec.com>; from luben_tuikov@adaptec.com on Tue, Sep 28, 2004 at 09:03:34AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 28, 2004 at 09:03:34AM -0400, Luben Tuikov wrote:
> Sync up drivers/scsi/aic7xxx/. (2231-2232)

This looks a lot like the internal command timeout handling that has been
rejected.

Please stop "syncup" madness.  We couldn't care less what's in Adaptecs
internal repository, especially if it's so bogus.  Please submit patches
that actually fix things.  One patch per issue, with a proper explanation.

