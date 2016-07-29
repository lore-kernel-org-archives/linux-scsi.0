From: J Freyensee <james_p_freyensee@linux.intel.com>
Subject: Re: [PATCH 2/5] nvme-fabrics: Add FC transport LLDD api definitions
Date: Fri, 29 Jul 2016 15:10:30 -0700
Message-ID: <1469830230.12212.46.camel@linux.intel.com>
References: <5792b91c.7HwdoM0qFRAjvQId%james.smart@broadcom.com>
	 <20160725091253.cq6lpgultbzleyq5@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:57927 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbcG2WKd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2016 18:10:33 -0400
In-Reply-To: <20160725091253.cq6lpgultbzleyq5@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On Mon, 2016-07-25 at 11:12 +0200, Johannes Thumshirn wrote:
> On Fri, Jul 22, 2016 at 05:23:56PM -0700, James Smart wrote:
> > 
> > nvme-fabrics: Add FC transport LLDD api definitions:
> > 
> > Host:
> > -LLDD registration with the host transport
> > -registering host ports (local ports) and target ports seen on
> >    fabric (remote ports)
> > -Data structures and call points for FC-4 LS's and FCP IO requests
> > 
> > Target:
> > -LLDD registration with the target transport
> > -registering nvme subsystem ports (target ports)
> > -Data structures and call points for reception of FC-4 LS's and
> >    FCP IO requests, and callbacks to perform data and rsp transfers
> >    for the io.
> > 
> > 
> > Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> Acked-by: Johannes Thumshirn <jth@kernel.org>

Acked-by: Jay Freyensee <james_p_freyensee@linux.intel.com>

> 
