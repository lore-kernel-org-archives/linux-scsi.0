From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH -next] scsi: fix advansys printk format warnings
Date: Wed, 16 Jul 2008 11:59:33 -0700
Message-ID: <1216234773.1862.6.camel@shinybook.infradead.org>
References: <20080716115057.47b3e117.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbYGPS7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 14:59:33 -0400
In-Reply-To: <20080716115057.47b3e117.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>, jaswinder@infradead.org

On Wed, 2008-07-16 at 11:50 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings (firmware-related):
> 
> linux-next-20080716/drivers/scsi/advansys.c:4788: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> linux-next-20080716/drivers/scsi/advansys.c:5117: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> linux-next-20080716/drivers/scsi/advansys.c:5631: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> linux-next-20080716/drivers/scsi/advansys.c:6131: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'


Thanks. We'll roll those into the original patches, if that's OK with
you.

-- 
dwmw2     @linux.intel.com

