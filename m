From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Fri, 7 Nov 2003 09:33:58 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031107093358.A1992@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B060ED69@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:47633 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263981AbTKGJd7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 04:33:59 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED69@AVEXCH02.qlogic.org>; from andrew.vasquez@qlogic.com on Thu, Nov 06, 2003 at 09:02:28AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

> 	o Failover -- DM and the fastfail infrastructure appear to be
> 	  in the early stages of adoption (implementation?).  There's
> 	  no question that QLogic will support the interfaces once
> 	  they mature.  Let's just agree to disagree...

Hey, there's no one saying you have to kill all your failover stuff.  Just
make it clearly optional and don't include it if_/when you submit the driver
for inclusion.  We just can't have a failover implementation for each vendor.
Not to mention that the LLDD really is the wrong place for it..

