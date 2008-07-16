From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] scsi: fix advansys printk format warnings
Date: Wed, 16 Jul 2008 12:20:18 -0700
Message-ID: <20080716122018.7720fda5.randy.dunlap@oracle.com>
References: <20080716115057.47b3e117.randy.dunlap@oracle.com>
	<1216234773.1862.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:64782 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYGPTUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 15:20:42 -0400
In-Reply-To: <1216234773.1862.6.camel@shinybook.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>, jaswinder@infradead.org

On Wed, 16 Jul 2008 11:59:33 -0700 David Woodhouse wrote:

> On Wed, 2008-07-16 at 11:50 -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix printk format warnings (firmware-related):
> > 
> > linux-next-20080716/drivers/scsi/advansys.c:4788: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> > linux-next-20080716/drivers/scsi/advansys.c:5117: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> > linux-next-20080716/drivers/scsi/advansys.c:5631: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> > linux-next-20080716/drivers/scsi/advansys.c:6131: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> 
> 
> Thanks. We'll roll those into the original patches, if that's OK with
> you.

Ack.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
