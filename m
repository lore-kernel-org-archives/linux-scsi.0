From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: scsi-misc BK tree: Fix scsi_device_get to allow NULL devices
Date: Mon, 5 Apr 2004 07:05:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405140552.GB8535@us.ibm.com>
References: <20040405125531.A4910@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:493 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S263394AbUDGBMA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 21:12:00 -0400
Content-Disposition: inline
In-Reply-To: <20040405125531.A4910@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> Can the SuSE guys please elaborate what this patch is supposed to solve?
> We should never pass a NULL pointer to scsi_device_get..

I agree. If this is happening then something is wrong in the scsi
support of the device model.

-andmike
--
Michael Anderson
andmike@us.ibm.com

