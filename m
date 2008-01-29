From: Roland Dreier <rdreier@cisco.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 29 Jan 2008 13:31:52 -0800
Message-ID: <adazluoe2t3.fsf@cisco.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	<1201639331.3069.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:33597 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYA2VcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2008 16:32:05 -0500
In-Reply-To: <1201639331.3069.58.camel@localhost.localdomain> (James Bottomley's message of "Tue, 29 Jan 2008 15:42:11 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

 > .                           .   STGT read     SCST read    .    STGT read      SCST read    .
 > .                           .  performance   performance   . performance    performance   .
 > .                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB, MB/s)   (1 MB, MB/s)  .
 > . iSER     (8 Gb/s network) .     250            N/A       .       360           N/A       .
 > . SRP      (8 Gb/s network) .     N/A            421       .       N/A           683       .

 > On the comparable figures, which only seem to be IPoIB they're showing a
 > 13-18% variance, aren't they?  Which isn't an incredible difference.

Maybe I'm all wet, but I think iSER vs. SRP should be roughly
comparable.  The exact formatting of various messages etc. is
different but the data path using RDMA is pretty much identical.  So
the big difference between STGT iSER and SCST SRP hints at some big
difference in the efficiency of the two implementations.

 - R.
