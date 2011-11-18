From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI oops on USB disconnect, was: Issues with xHCI and USB 3.0
Date: Fri, 18 Nov 2011 12:31:14 +0100
Message-ID: <CAO+b5-oY8qnhL=6tR2TO3HC1NJKEx_2x4SOTqFW5ZSnbf48Urg@mail.gmail.com>
References: <4EA54EBF.80905@iinet.net.au>
	<20111025072957.GA5821@xanatos>
	<4EA68418.9000504@iinet.net.au>
	<20111025113458.GA4590@xanatos>
	<4EA6B3FC.9010808@iinet.net.au>
	<20111027112831.GB4790@xanatos>
	<20111102190224.GB29845@xanatos>
	<4EB24040.1060208@iinet.net.au>
	<20111103202258.GA3585@xanatos>
	<4EB32928.6000901@iinet.net.au>
	<20111104144840.GA3079@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1KRLbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2011 06:31:17 -0500
In-Reply-To: <20111104144840.GA3079@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Matt <mdm@iinet.net.au>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>

On Fri, Nov 4, 2011 at 3:48 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> [ =A0325.497799] Call Trace:
> [ =A0325.499007] =A0[<ffffffff8122c4eb>] ? blk_peek_request+0x3f/0x1d=
2
> [ =A0325.500236] =A0[<ffffffff813148e3>] scsi_request_fn+0x48/0x409
> [ =A0325.501461] =A0[<ffffffff811163d4>] ? kmem_cache_free+0x72/0xab
> [ =A0325.502685] =A0[<ffffffff81227338>] __blk_run_queue+0x1b/0x1d
> [ =A0325.503906] =A0[<ffffffff8131428a>] scsi_run_queue+0x1c0/0x22d
> [ =A0325.505126] =A0[<ffffffff813153d4>] scsi_next_command+0x39/0x49
> [ =A0325.506337] =A0[<ffffffff81315895>] scsi_io_completion+0x45d/0x4=
d7
> [ =A0325.507552] =A0[<ffffffff8130dc14>] scsi_finish_command+0xe4/0xe=
d
> [ =A0325.508761] =A0[<ffffffff81312a3e>] scsi_eh_flush_done_q+0xfc/0x=
124
> [ =A0325.509971] =A0[<ffffffff8131310e>] scsi_error_handler+0x383/0x5=
91
> [ =A0325.511175] =A0[<ffffffff81312d8b>] ? scsi_eh_get_sense+0x183/0x=
183
> [ =A0325.512380] =A0[<ffffffff81072a17>] kthread+0x84/0x8c
> [ =A0325.513580] =A0[<ffffffff814b01f4>] kernel_thread_helper+0x4/0x1=
0
> [ =A0325.514782] =A0[<ffffffff81072993>] ? kthread_worker_fn+0x148/0x=
148
>
> Hopefully the SCSI folks will be able to help you with that. =A0James=
?

Might be the same issue as this one:
http://www.spinics.net/lists/linux-scsi/msg55497.html.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
