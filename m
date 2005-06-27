From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: Kernel 2.6.12x breaks the qlaxxxx driver
Date: Mon, 27 Jun 2005 16:59:11 -0700
Message-ID: <200506272359.j5RNxBg26526@unix-os.sc.intel.com>
References: <200506271817.09202.jm@wo.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr22.intel.com ([143.183.121.14]:63421 "EHLO
	scsfmr002.sc.intel.com") by vger.kernel.org with ESMTP
	id S262036AbVF0X7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 19:59:20 -0400
In-Reply-To: <200506271817.09202.jm@wo.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jan Merka' <jm@wo.cz>, andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

Jan Merka wrote on Monday, June 27, 2005 3:17 PM
> The 2.6.12 and 2.6.12.1 kernels break the qlaxxxx driver(s).

I thought someone on this list said it is fixed in 2.6.12.1.  I guess it
is not.  I had the same problem last week and applying this patch works
for me.

http://marc.theaimsgroup.com/?l=linux-scsi&m=111836291000433&w=2

