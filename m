From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.6.5-rc1 SCSI + st regressions (was: Linux 2.6.5-rc1)
Date: Wed, 17 Mar 2004 15:04:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040317230457.GB3946@beaverton.ibm.com>
References: <Pine.LNX.4.58.0403152154070.19853@ppc970.osdl.org> <20040316211203.GA3679@merlin.emma.line.org> <20040316211700.GA25059@parcelfarce.linux.theplanet.co.uk> <20040316215659.GA3861@merlin.emma.line.org> <Pine.LNX.4.58.0403172145420.1093@kai.makisara.local> <Pine.LNX.4.58.0403172312410.1093@kai.makisara.local> <20040317214434.GF949@beaverton.ibm.com> <Pine.LNX.4.58.0403180022420.1090@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:34973 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262136AbUCQXGU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 18:06:20 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0403180022420.1090@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Matthias Andree <ma+lscsi@dt.e-technik.uni-dortmund.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>

Kai Makisara [Kai.Makisara@kolumbus.fi] wrote:
> On Wed, 17 Mar 2004, Mike Anderson wrote:
> A revised patch is at the end of this message. Thanks for pointing out 
> this bug.

Thanks for the update. I checked it out on my system with a aic and a
TDC 3800 tape drive. It works fine.

-andmike
--
Michael Anderson
andmike@us.ibm.com

