From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it
 isn't provided
Date: Fri, 5 Dec 2014 21:37:47 +0800
Message-ID: <CACVXFVO-faCX-yHhrvb=Rt8TS9WcVT2nSMXEbss6mOhaKfC49g@mail.gmail.com>
References: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>
	<yq1r3wefe6o.fsf@sermon.lab.mkp.net>
	<CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>
	<yq1mw72fczo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaLENht (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 08:37:49 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1Xwt4u-0002ER-CZ
	for linux-scsi@vger.kernel.org; Fri, 05 Dec 2014 13:37:48 +0000
Received: by mail-ob0-f176.google.com with SMTP id vb8so479556obc.35
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2014 05:37:47 -0800 (PST)
In-Reply-To: <yq1mw72fczo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>

On Fri, Dec 5, 2014 at 9:22 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Ming" == Ming Lei <ming.lei@canonical.com> writes:
>
>>> There is absolutely no correlation between max write same blocks and
>>> max unmap blocks. They are two entirely different commands. If QEMU
>>> SCSI
>
> Ming> Do you have any better idea for the problem?
>
> Does QEMU SCSI set LBPRZ?

It isn't set in LBP VPG page.

Thanks,
