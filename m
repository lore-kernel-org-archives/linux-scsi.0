From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] remove CONFIG_SCSI_QLOGIC_1280_1040
Date: Thu, 10 Nov 2005 12:05:55 -0500
Message-ID: <1131642356.3336.14.camel@mulgrave>
References: <20051110104159.GA689@lst.de>
Reply-To: James.Bottomley@steeleye.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:60810 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750896AbVKJRGF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 12:06:05 -0500
In-Reply-To: <20051110104159.GA689@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2005-11-10 at 11:41 +0100, Christoph Hellwig wrote:
> now that qlogicisp is gone there is not reason not to support the 1040
> unconditionally in qla1280.
> 
> Would be nice to get this into 2.6.15 still.

Adrian Bunk already beat you to this.  It was part of the isp removal
patch ...

James


