From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 35282] BUG() in 2.6.38.6
Date: Tue, 17 May 2011 23:55:02 +0400
Message-ID: <1305662102.2667.25.camel@mulgrave.site>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
	 <201105171917.p4HJHUhx019356@demeter2.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51059 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932141Ab1EQTzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2011 15:55:09 -0400
In-Reply-To: <201105171917.p4HJHUhx019356@demeter2.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 2011-05-17 at 19:17 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=35282


> May 15 16:09:32 192.168.42.2 Call Trace:
> May 15 16:09:32 192.168.42.2 <IRQ>
> May 15 16:09:32 192.168.42.2
> May 15 16:09:32 192.168.42.2 [<ffffffff812160eb>] ? __blk_run_queue+0x24/0x7e
> May 15 16:09:32 192.168.42.2 [<ffffffff81216167>] ? blk_run_queue+0x22/0x34
> May 15 16:09:32 192.168.42.2 [<ffffffff812b2fde>] ? scsi_run_queue+0x2ce/0x36d
> May 15 16:09:32 192.168.42.2 [<ffffffff812b39ef>] ? scsi_next_command+0x2d/0x39
> May 15 16:09:32 192.168.42.2 [<ffffffff812b4289>] ?
> scsi_io_completion+0x1ca/0x3fd

This looks like it might be related to the queue guard in
__elv_next_request() again,  could you try this patch:

http://marc.info/?l=linux-scsi&m=130348673628282

Thanks,

James


