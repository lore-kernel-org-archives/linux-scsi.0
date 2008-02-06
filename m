From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 6 Feb 2008 13:16:43 +0100
Message-ID: <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <47A89660.1080804@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:42284 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762225AbYBFMQt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 07:16:49 -0500
Received: by wr-out-0506.google.com with SMTP id c48so2597816wra.23
        for <linux-scsi@vger.kernel.org>; Wed, 06 Feb 2008 04:16:45 -0800 (PST)
In-Reply-To: <47A89660.1080804@Voltaire.COM>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@voltaire.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Feb 5, 2008 6:01 PM, Erez Zilber <erezz@voltaire.com> wrote:
>
> Using such large values for FirstBurstLength will give you poor
> performance numbers for WRITE commands (with iSER). FirstBurstLength
> means how much data should you send as unsolicited data (i.e. without
> RDMA). It means that your WRITE commands were sent without RDMA.

Sorry, but I'm afraid you got this wrong. When the iSER transport is
used instead of TCP, all data is sent via RDMA, including unsolicited
data. If you have look at the iSER implementation in the Linux kernel
(source files under drivers/infiniband/ulp/iser), you will see that
all data is transferred via RDMA and not via TCP/IP.

Bart Van Assche.
