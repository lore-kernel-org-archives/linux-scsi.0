From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 3787] New: Badness in
	scsi_device_set_state at drivers/scsi/scsi_lib.c:1717
Date: 21 Nov 2004 17:25:46 -0600
Message-ID: <1101079564.2131.3.camel@mulgrave>
References: <20041121123832.3afab90f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40595 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261850AbUKUX2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Nov 2004 18:28:25 -0500
In-Reply-To: <20041121123832.3afab90f.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-11-21 at 14:38, Andrew Morton wrote:
> Begin forwarded message:
> 
> Date: Sun, 21 Nov 2004 06:25:30 -0800
> From: bugme-daemon@osdl.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 3787] New: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1717

The fix for this should be upstream already (sent in the last lot of -rc
fixes):

ChangeSet@1.2184, 2004-11-18 17:00:19-06:00, jejb@mulgrave.(none)
  SCSI: fix USB forced remove oops

I'm afraid this is my fault ... I created the fix some time ago and just
forgot to apply (or rather thought I already had applied) it.

Anyway, this is a warning to everyone ... just because I come up with a
fix for a problem, it doesn't mean I'll remember to apply it, so if you
care about it ... remind me!

James


