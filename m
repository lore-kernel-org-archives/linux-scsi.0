From: David Strand <dpstrand@gmail.com>
Subject: Re: [dm-devel] blk_abort_queue on failed paths?
Date: Thu, 4 Jun 2009 13:35:49 -0700
Message-ID: <448b15030906041335l6177a1cfgb227643c4ca9bc2@mail.gmail.com>
References: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com>
	 <4A26ED7D.1010203@cs.wisc.edu> <4A280DDF.7070205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:43165 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZFDUfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2009 16:35:47 -0400
Received: by qw-out-2122.google.com with SMTP id 5so729149qwd.37
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2009 13:35:49 -0700 (PDT)
In-Reply-To: <4A280DDF.7070205@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

>> What driver were you using?
>
> Oh yeah, I do not think this should happen in new kernels if the driver is
> failing the IO with DID_TRANSPORT_DISRUPTED when it is deleting the rport.
> That should cause the IO to requeue and wait for fast io fail to fire.
>
> Maybe we just need to convert some more drivers?

I am using the 2.6.29 mptfc driver, which I believe relies on
scsi_transport_fc.c, which does not appear to support
DID_TRANSPORT_DISRUPTED.
