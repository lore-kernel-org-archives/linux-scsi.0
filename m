From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 14:33:59 +0300
Message-ID: <4795D4A7.5000105@vlnb.net>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>	 <20080117184052F.fujita.tomonori@lab.ntt.co.jp>	 <478F246C.4040400@vlnb.net>	 <20080117190558K.fujita.tomonori@lab.ntt.co.jp>	 <20080117174542.GC29650@osc.edu> <e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:40257 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbYAVLdw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 06:33:52 -0500
In-Reply-To: <e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Pete Wyckoff <pw@osc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@hansenpartnership.com, erezz@voltaire.com

Bart Van Assche wrote:
> On Jan 17, 2008 6:45 PM, Pete Wyckoff <pw@osc.edu> wrote:
> 
>>There's nothing particularly stunning here.  Suspect Bart has
>>configuration issues if not even IPoIB will do > 100 MB/s.
> 
> 
> By this time I found out that the BIOS of the test systems (Intel
> Server Board S5000PAL) set the PCI-e parameter MaxReadReq to 128
> bytes, which explains the low InfiniBand performance. After changing
> this parameter to 4096 bytes the InfiniBand throughput was as
> expected: ib_rdma_bw now reports a
> bandwidth of 933 MB/s.

What are the new SRPT/iSER numbers?

> Bart.
> 

