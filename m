From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Hidden scsi devices
Date: Thu, 22 Jan 2004 15:50:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122155040.A12452@infradead.org>
References: <400FEA73.80109@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:23562 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264501AbUAVPuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 10:50:46 -0500
Content-Disposition: inline
In-Reply-To: <400FEA73.80109@us.ibm.com>; from brking@us.ibm.com on Thu, Jan 22, 2004 at 09:21:23AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Ok.  Although I'd maybe write it a bit more compact, and a bit commentary
could't hurt.

/*
 * Sort out hidden devices early.  All real probing is done in the
 * individual ->probe routines
 */
static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
{
	struct scsi_device *sdev = to_scsi_device(dev);

	return (sdev->hidden ? 0 : 1);
}

