From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi host/scsi device ref count cleanup 2/4
Date: Wed, 9 Jul 2003 08:39:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030709083937.A21371@infradead.org>
References: <20030708222447.GA2232@beaverton.ibm.com> <20030708222541.GB2232@beaverton.ibm.com> <20030708222622.GC2232@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:44816 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265877AbTGIJfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2003 05:35:12 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 19a9YA-0005Yn-00
	for linux-scsi@vger.kernel.org; Wed, 09 Jul 2003 08:39:38 +0100
Content-Disposition: inline
In-Reply-To: <20030708222622.GC2232@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Jul 08, 2003 at 03:26:22PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Jul 08, 2003 at 03:26:22PM -0700, Mike Anderson wrote:
> aic79xx_osm and aic7xxx_osm are 2.4 code. ioctl_probe has side effect of
> needing present value.

ioctl_probe is pretty buggy anyways.  I wonder whether we should just kill it.

