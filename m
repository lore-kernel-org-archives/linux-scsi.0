From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_dd bpt= count=
Date: 20 Oct 2003 12:21:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066674092.2833.0.camel@patehci2>
References: <1066174844.3399.6.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:35458 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262790AbTJTSVm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 14:21:42 -0400
In-Reply-To: <1066174844.3399.6.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> > I find some bugs "interesting".
>
> sudo sg_dd of=/dev/sg0 if=/dev/zero bs=2k bpt= count=
> may reliably take down kernels.
>
> I say this because I saw 2.6.0-test7 go down twice,

And now also 2.6.0-test8.  This time ping survived, but again ssh did
not, and Ctrl+Alt+F$n doesn't give me an alternate console.

> my sg utils are the latest available

Confirmed:
http://www.torque.net/sg/p/sg3_utils-1.05.tgz
`cksum` reports: 4285724795 188010 sg3_utils-1.05.tgz

Pat LaVarre


