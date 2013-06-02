From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ipr: qc_fill_rtf() method should not store alternate
 status register
Date: Sun, 2 Jun 2013 01:15:23 -0700
Message-ID: <20130602081523.GE8286@mtj.dyndns.org>
References: <201305212324.22822.sergei.shtylyov@cogentembedded.com>
 <51A89BBB.1030705@linux.vnet.ibm.com>
 <51A9260C.20504@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61140 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3FBIP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jun 2013 04:15:27 -0400
Content-Disposition: inline
In-Reply-To: <51A9260C.20504@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sat, Jun 01, 2013 at 02:37:00AM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 05/31/2013 04:46 PM, Brian King wrote:
> 
> >
> >>The 'ctl' field of  the 'struct ata_taskfile' is not really dual purpose, i.e.
> >>it is not intended  for storing the alternate status register (which is mapped
> >>at the same address in the legacy IDE controllers) in the qc_fill_rtf() method.
> >>No other 'libata' driver except 'drivers/scsi/ipr.c' stores the alternate status
> >>register's value in the 'ctl' field of 'qc->result_tf', hence this driver should
> >>not do this as well...
> >>
> >>Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> >Acked-by: Brian King <brking@linux.vnet.ibm.com>
> >
> 
>     Tejun, I would prefer that this patch be merged thru the libata tree
> as my future cleanup patches depend on it.

Applied to libata/for-3.11 w/ Brian's ack added.

Thanks.

-- 
tejun
