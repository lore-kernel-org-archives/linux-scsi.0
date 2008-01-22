From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 11:04:15 +0100
Message-ID: <e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	 <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	 <478F246C.4040400@vlnb.net>
	 <20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	 <20080117174542.GC29650@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:28387 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbYAVKES (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 05:04:18 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1354181nze.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jan 2008 02:04:16 -0800 (PST)
In-Reply-To: <20080117174542.GC29650@osc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, vst@vlnb.net, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@hansenpartnership.com, erezz@voltaire.com

On Jan 17, 2008 6:45 PM, Pete Wyckoff <pw@osc.edu> wrote:
> There's nothing particularly stunning here.  Suspect Bart has
> configuration issues if not even IPoIB will do > 100 MB/s.

By this time I found out that the BIOS of the test systems (Intel
Server Board S5000PAL) set the PCI-e parameter MaxReadReq to 128
bytes, which explains the low InfiniBand performance. After changing
this parameter to 4096 bytes the InfiniBand throughput was as
expected: ib_rdma_bw now reports a
bandwidth of 933 MB/s.

Bart.
