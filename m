From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] sd: Fix regression in sd_read_cache_type
Date: Wed, 23 Mar 2011 08:54:32 -0700 (PDT)
Message-ID: <358235.77053.qm@web31810.mail.mud.yahoo.com>
References: <1300893408.15899.17.camel@mulgrave.site>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13-vm1.bullet.mail.sp2.yahoo.com ([98.139.91.245]:48299 "HELO
	nm13-vm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756466Ab1CWPyd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 11:54:33 -0400
In-Reply-To: <1300893408.15899.17.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Richard Senior <richard@r-senior.demon.co.uk>, SCSI development list <linux-scsi@vger.kernel.org>

--- On Wed, 3/23/11, James Bottomley <James.Bottomley@suse.de> wrote:
> 
> I put the original patch in on the understanding from both
> of you that
> the chances of finding a USB device which crashed with the
> change was
> very small.

Bottomley, obviously there are no guarantees in life. This is what bug fixes and code development is all about. It's all about making things better for for a wider range of NEW devices.

> Given that several have been found and we're on the eve of
> the merge window closure,

It wouldn't have mattered it if was found two weeks ago or in a month.

> I'll just revert the original,

Obviously you don't have to do that if you applied Alan patch.

> and you two can work on getting a bullet proof version for the next
> merge window.

Here is what happened: I submitted a patch and it was generally liked. To
refresh your memory here is the thread: http://marc.info/?t=129044508400003&r=1&w=2. The patch was applied. Then an odd device was
found, as reported by Alan, who fixed it, and submitted a patch. He agreed
that his patch works on top of mine to fix the problem. It was verified to
fix the problem by Richard. Then I agreed with Alan that his patch works
on top of mine to fix the problem by acking it as you can see in this
thread. So Alan and I have both agreed that this is, at the moment, a
"bullet-proof" version for this and any other merge window.

Having said that, you should be aware that no patch is "bullet-proof",
neither is the SCSI Layer, nor is the Linux kernel. That is, as technology
goes forward.

If you prefer to revert the original patch, I can resubmit the original
patch with Alan's patch on top of it (as it is a fix for the original,
larger, topic patch), and then you can apply that.

Let me know what would work for you Bottomley.

    Luben

