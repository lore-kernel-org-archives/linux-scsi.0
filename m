From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Question on qla2xxx Kconfig update in 2.6.2
Date: Thu, 5 Feb 2004 08:58:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040205165807.GB2498@beaverton.ibm.com>
References: <20040205163722.GA2498@beaverton.ibm.com> <1075999192.1756.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:59339 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S266030AbUBEQxa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 11:53:30 -0500
Content-Disposition: inline
In-Reply-To: <1075999192.1756.23.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Thu, 2004-02-05 at 11:37, Mike Anderson wrote:
> > Is the usage of SCSI_QLA2XXX_CONFIG instead of SCSI_QLA2XXX correct in
> > drivers/scsi/qla2xxx/Kconfig or have I just not had enough coffee this morning?
> > 
> > After a fresh bk pull and make config I could not get the qla2xxx
> > directory selected during a make modules. If I change to using SCSI_QLA2XXX in the Kconfig file everything is fine.
> 
> Erk, my fault.  I quietly fixed it by altering drivers/scsi/Makefile (to
> make obj-$(CONFIG_SCSI_QLA2XXX_CONFIG) += qla2xxx/)
> 

ok.

Should we fix it the other way around (i.e., have qla2xxx Kconfig
use SCSI_QLA2XXX) to be consistent with other Kconfig users. I see only
one other in the .config file that I am using that has a _CONFIG postfix.

-andmike
--
Michael Anderson
andmike@us.ibm.com

