From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Question on qla2xxx Kconfig update in 2.6.2
Date: 05 Feb 2004 11:39:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075999192.1756.23.camel@mulgrave>
References: <20040205163722.GA2498@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:60897 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266494AbUBEQkp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 11:40:45 -0500
In-Reply-To: <20040205163722.GA2498@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Thu, 2004-02-05 at 11:37, Mike Anderson wrote:
> Is the usage of SCSI_QLA2XXX_CONFIG instead of SCSI_QLA2XXX correct in
> drivers/scsi/qla2xxx/Kconfig or have I just not had enough coffee this morning?
> 
> After a fresh bk pull and make config I could not get the qla2xxx
> directory selected during a make modules. If I change to using SCSI_QLA2XXX in the Kconfig file everything is fine.

Erk, my fault.  I quietly fixed it by altering drivers/scsi/Makefile (to
make obj-$(CONFIG_SCSI_QLA2XXX_CONFIG) += qla2xxx/)

but then I apparently lost it from the tree on a rebuild.

I'll add it back.

James


