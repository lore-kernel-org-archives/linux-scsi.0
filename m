From: Erez Zilber <erezz@Voltaire.COM>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 19:01:20 +0200
Message-ID: <47A89660.1080804@Voltaire.COM>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1201639331.3069.58.camel@localhost.localdomain>	 <adazluoe2t3.fsf@cisco.com>	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp> <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:21665 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751954AbYBERBW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 12:01:22 -0500
In-Reply-To: <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>   
>> iSER has parameters to limit the maximum size of RDMA (it needs to
>> repeat RDMA with a poor configuration)?
>>     
>
> Please specify which parameters you are referring to. As you know I
> had already repeated my tests with ridiculously high values for the
> following iSER parameters: FirstBurstLength, MaxBurstLength and
> MaxRecvDataSegmentLength (16 MB, which is more than the 1 MB block
> size specified to dd).
>
>   
Using such large values for FirstBurstLength will give you poor
performance numbers for WRITE commands (with iSER). FirstBurstLength
means how much data should you send as unsolicited data (i.e. without
RDMA). It means that your WRITE commands were sent without RDMA.

Erez
