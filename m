From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.6.5-rc1 SCSI + st regressions (was: Linux 2.6.5-rc1)
Date: Wed, 17 Mar 2004 13:44:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040317214434.GF949@beaverton.ibm.com>
References: <Pine.LNX.4.58.0403152154070.19853@ppc970.osdl.org> <20040316211203.GA3679@merlin.emma.line.org> <20040316211700.GA25059@parcelfarce.linux.theplanet.co.uk> <20040316215659.GA3861@merlin.emma.line.org> <Pine.LNX.4.58.0403172145420.1093@kai.makisara.local> <Pine.LNX.4.58.0403172312410.1093@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:39097 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262089AbUCQVqF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 16:46:05 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0403172312410.1093@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Matthias Andree <ma+lscsi@dt.e-technik.uni-dortmund.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>

Kai Makisara [Kai.Makisara@kolumbus.fi] wrote:
>  		if (!st_class_member) {
>  			printk(KERN_WARNING "st%d: class_simple_device_add failed\n",
>  			       dev_num);

Could you change the if check to use IS_ERR(st_class_member) so in the
future if do_create_class_files return -E* we will not get a oops.

-andmike
--
Michael Anderson
andmike@us.ibm.com

