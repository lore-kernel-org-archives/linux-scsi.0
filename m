From: Roland Dreier <rdreier@cisco.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 06 Feb 2008 09:06:37 -0800
Message-ID: <ada8x1ydnfm.fsf@cisco.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	<1201639331.3069.58.camel@localhost.localdomain>
	<adazluoe2t3.fsf@cisco.com>
	<20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	<e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	<47A89660.1080804@Voltaire.COM>
	<e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:47116 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYBFRGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 12:06:52 -0500
In-Reply-To: <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com> (Bart Van Assche's message of "Wed, 6 Feb 2008 13:16:43 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Erez Zilber <erezz@voltaire.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

 > Sorry, but I'm afraid you got this wrong. When the iSER transport is
 > used instead of TCP, all data is sent via RDMA, including unsolicited
 > data. If you have look at the iSER implementation in the Linux kernel
 > (source files under drivers/infiniband/ulp/iser), you will see that
 > all data is transferred via RDMA and not via TCP/IP.

I think the confusion here is caused by a slight misuse of the term
"RDMA".  It is true that all data is always transported over an
InfiniBand connection when iSER is used, but not all such transfers
are one-sided RDMA operations; some data can be transferred using
send/receive operations.

 - R.

