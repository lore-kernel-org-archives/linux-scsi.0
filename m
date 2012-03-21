From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Tue, 20 Mar 2012 20:37:55 -0700
Message-ID: <CAA9_cmdp7Ov7ZrCv+NEuxs9WXAk0ts7uOo2UDxBAd_feT6gPLQ@mail.gmail.com>
References: <4F65E09D.6010600@acm.org>
	<20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com>
	<4F663BE3.4000503@acm.org>
	<20120319170435.GH11069@google.com>
	<4F68E34F.1060502@acm.org>
	<CAA9_cmcZUueDCc2dZXayWDqAoggXo1+pqqjpk8VLEbk5wrtdDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43082 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2CUDh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 23:37:56 -0400
Received: by vbbff1 with SMTP id ff1so311900vbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 20 Mar 2012 20:37:55 -0700 (PDT)
In-Reply-To: <CAA9_cmcZUueDCc2dZXayWDqAoggXo1+pqqjpk8VLEbk5wrtdDA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bartek Nowakowski <bartek.nowakowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>

On Tue, Mar 20, 2012 at 2:01 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Tue, Mar 20, 2012 at 1:06 PM, Bart Van Assche <bvanassche@acm.org>=
 wrote:
> [..]
>> - Fix a null pointer dereference triggered by sd during device remov=
al.
>
> Hi Bart,
>
> Do you have a log of the backtrace in this case? =A0I'm going to put
> this patch into our libsas/isci test environment.

We beat on this patch pretty severely in our environment and appeared
to only trigger a hung_task timeout when our driver / libata took too
long to recovery for a 15 device unplug. So...

Acked-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Jacek Danecki <jacek.danecki@intel.com>
Tested-by: Bartek Nowakowski <bartek.nowakowski@intel.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
