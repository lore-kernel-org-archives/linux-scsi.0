From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Date: Thu, 24 Sep 2009 15:33:12 -0700
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F81B@HQ-EXCH-7.corp.brocade.com>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
	 <1253807042.20648.188.camel@desktop>
	 <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F77D@HQ-EXCH-7.corp.brocade.com>
	 <1253814934.20648.262.camel@desktop>
	 <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F79B@HQ-EXCH-7.corp.brocade.com>
 <1253831331.5183.264.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:41940 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIXWdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 18:33:09 -0400
In-Reply-To: <1253831331.5183.264.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Krishna Gudipati <kgudipat@Brocade.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

> > Thanks. I found the problem. I tried the latest checkpatch in 2.6.31
> > and it generates a lot of ERRORs about putting parentheses for return.
> > I have been using an older version of checkpatch for patch submission
> > all the time, and therefore I didn't see any problem. I will fix them
> > and resubmit the patch.
> 
> Actually, could you send an incremental diff ... I'll put this in the
> tree because it's about time it got wider testing in linux-next.
> 
> James
> 

Thanks James, I am working on the fix, and I will send an incremental diff.

Jing

