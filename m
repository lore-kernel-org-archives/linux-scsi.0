From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi-misc BK tree: Fix scsi_device_get to allow NULL devices
Date: Mon, 19 Apr 2004 10:38:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040419103822.A9502@infradead.org>
References: <20040405125531.A4910@infradead.org> <20040405140552.GB8535@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:60428 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264335AbUDSJiY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 05:38:24 -0400
Content-Disposition: inline
In-Reply-To: <20040405140552.GB8535@us.ibm.com>; from andmike@us.ibm.com on Mon, Apr 05, 2004 at 07:05:52AM -0700
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Mon, Apr 05, 2004 at 07:05:52AM -0700, Mike Anderson wrote:
> Christoph Hellwig [hch@infradead.org] wrote:
> > Can the SuSE guys please elaborate what this patch is supposed to solve?
> > We should never pass a NULL pointer to scsi_device_get..
> 
> I agree. If this is happening then something is wrong in the scsi
> support of the device model.

As no one stands up to defend the patch could we please remove it again?
I saw it made it into 2.6.6-rc1 despite the critisism.

