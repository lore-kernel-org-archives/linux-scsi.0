From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Date: Thu, 24 Sep 2009 11:08:31 -0700
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F79B@HQ-EXCH-7.corp.brocade.com>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
	 <1253807042.20648.188.camel@desktop>
	 <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F77D@HQ-EXCH-7.corp.brocade.com>
 <1253814934.20648.262.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:38796 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZIXSI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 14:08:29 -0400
In-Reply-To: <1253814934.20648.262.camel@desktop>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Krishna Gudipati <kgudipat@Brocade.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

> > Hi Daniel,
> >
> > I did run checkpatch.pl and it didn't report any ERROR or WARNING. Do
> you use any specific flags?
> 
> No nothing special .. I run it in the following way,
> 
> ./scripts/checkpatch.pl this-is-the-test.patch
> 
> or
> 
> cat this-is-the-test.patch | ./scripts/checkpatch.pl -
> 
> how did you run it? Usually it will report something like the following
> if it finds nothing,
> 
> total: 0 errors, 0 warnings, XXX lines checked
> 
> Your patch has no obvious style problems and is ready for submission.
> 
> 
> 
> Daniel

Thanks. I found the problem. I tried the latest checkpatch in 2.6.31 and it generates a lot of ERRORs about putting parentheses for return. I have been using an older version of checkpatch for patch submission all the time, and therefore I didn't see any problem. I will fix them and resubmit the patch.

Jing 

