From: Christoph Hellwig <hch@infradead.org>
Subject: Re: clustering and 2.6
Date: Tue, 7 Sep 2004 17:34:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907173427.A17284@infradead.org>
References: <20040907161254.GA23325@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:29703 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268200AbUIGQec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 12:34:32 -0400
Content-Disposition: inline
In-Reply-To: <20040907161254.GA23325@beardog.cca.cpqcorp.net>; from mikem@beardog.cca.cpqcorp.net on Tue, Sep 07, 2004 at 11:12:54AM -0500
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Tue, Sep 07, 2004 at 11:12:54AM -0500, mikem wrote:
> The SCSI mid-layer sets a bogus size on a device when read capacity fails.
> Is this the preferred way to get around this issue? Seems like there
> should be a better way.

you need to write something (anything works) to the rescan attribute of
each lun.
