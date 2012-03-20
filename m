From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Tue, 20 Mar 2012 14:01:55 -0700
Message-ID: <CAA9_cmcZUueDCc2dZXayWDqAoggXo1+pqqjpk8VLEbk5wrtdDA@mail.gmail.com>
References: <4F65E09D.6010600@acm.org>
	<20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com>
	<4F663BE3.4000503@acm.org>
	<20120319170435.GH11069@google.com>
	<4F68E34F.1060502@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44117 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab2CTVB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 17:01:56 -0400
Received: by vbbff1 with SMTP id ff1so200980vbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 20 Mar 2012 14:01:55 -0700 (PDT)
In-Reply-To: <4F68E34F.1060502@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Mar 20, 2012 at 1:06 PM, Bart Van Assche <bvanassche@acm.org> wrote:
[..]
> - Fix a null pointer dereference triggered by sd during device removal.

Hi Bart,

Do you have a log of the backtrace in this case?  I'm going to put
this patch into our libsas/isci test environment.

Thanks,
Dan
