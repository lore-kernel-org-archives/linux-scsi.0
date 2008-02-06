From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 06 Feb 2008 18:45:47 +0200
Message-ID: <47A9E43B.3030407@panasas.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1201639331.3069.58.camel@localhost.localdomain>	 <adazluoe2t3.fsf@cisco.com>	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>	 <47A89660.1080804@Voltaire.COM> <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:38031 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbYBFQsx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 11:48:53 -0500
In-Reply-To: <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Erez Zilber <erezz@voltaire.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Feb. 06, 2008, 14:16 +0200, "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
> On Feb 5, 2008 6:01 PM, Erez Zilber <erezz@voltaire.com> wrote:
>> Using such large values for FirstBurstLength will give you poor
>> performance numbers for WRITE commands (with iSER). FirstBurstLength
>> means how much data should you send as unsolicited data (i.e. without
>> RDMA). It means that your WRITE commands were sent without RDMA.
> 
> Sorry, but I'm afraid you got this wrong. When the iSER transport is
> used instead of TCP, all data is sent via RDMA, including unsolicited
> data. If you have look at the iSER implementation in the Linux kernel
> (source files under drivers/infiniband/ulp/iser), you will see that
> all data is transferred via RDMA and not via TCP/IP.

Regardless of what the current implementation is, the behavior you (Bart)
describe seems to disagree with http://www.ietf.org/rfc/rfc5046.txt.

Benny

> 
> Bart Van Assche.
> -

