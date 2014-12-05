From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it
 isn't provided
Date: Fri, 5 Dec 2014 21:47:56 +0800
Message-ID: <CACVXFVM7A2Y+g8gQL4-LMcvp-qpx6kuKbr51gx4paGe1NLyb2A@mail.gmail.com>
References: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>
	<yq1r3wefe6o.fsf@sermon.lab.mkp.net>
	<CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>
	<yq1mw72fczo.fsf@sermon.lab.mkp.net>
	<CACVXFVO-faCX-yHhrvb=Rt8TS9WcVT2nSMXEbss6mOhaKfC49g@mail.gmail.com>
	<yq1iohqfc7i.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35665 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbaLENr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 08:47:59 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1XwtEj-0002cU-VM
	for linux-scsi@vger.kernel.org; Fri, 05 Dec 2014 13:47:58 +0000
Received: by mail-oi0-f44.google.com with SMTP id e131so454745oig.3
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2014 05:47:56 -0800 (PST)
In-Reply-To: <yq1iohqfc7i.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>

On Fri, Dec 5, 2014 at 9:38 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Ming" == Ming Lei <ming.lei@canonical.com> writes:
>
> Ming> It isn't set in LBP VPG page.
>
> What about in READ CAPACITY(16)?

It isn't set too.

Thanks,
Ming Lei
