From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
Date: Fri, 3 Sep 2004 00:58:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040903005804.A30329@infradead.org>
References: <200409021719.15267.bjorn.helgaas@hp.com> <1094168177.2097.154.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:15877 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269403AbUIBX6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2004 19:58:13 -0400
Content-Disposition: inline
In-Reply-To: <1094168177.2097.154.camel@mulgrave>; from James.Bottomley@SteelEye.com on Thu, Sep 02, 2004 at 07:36:15PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Sep 02, 2004 at 07:36:15PM -0400, James Bottomley wrote:
> > Is there any interest in a patch like the attached, which makes
> > things look like this:
> 
> Not really, unless it's part of a conversion to dev_printk().

In addition the patch will crash the box for all the legacy drivers
that don't set the device field in struct Scsi_Host

