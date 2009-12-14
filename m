From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: how to recover from "medium format corrupted"?
Date: Mon, 14 Dec 2009 13:24:26 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912141307190.2915@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912140158580.2915@bogon.housecafe.de> <4B264C83.4080009@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:56656 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059AbZLNVYb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2009 16:24:31 -0500
In-Reply-To: <4B264C83.4080009@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 14 Dec 2009 at 15:32, Douglas Gilbert wrote:
> Could you try the '--wait' option on the sg_format?

After sending out my mail to linux-scsi (as a last resort, I thought) I 
decided to boot into Solaris again. Although "format" was not too happy 
accessing the disk (and was even dumping core quite often), it was able to 
get hold of the disk, somehow. I issued to FORMAT command again but this 
time let it run and it completed to 97% - when it exited with a segfault. 
But that must've been enough, as I'm now able to access the disk again, 
under Linux too.

> The disk
> does not seem to respond to the TEST UNIT READY poll. If
> it is a modern disk it might respond to a REQUEST SENSE poll
> but sg_format doesn't support that yet.

It's a ST373307LC (Cheetah 10K.6), I think they were made 2003 or 
something. I'll see if I can use lsiutil to send those commands directly 
from the HBA.

> The '--wait' option will leave sg_format hanging until the
> FORMAT UNIT finishes or 4 hours expires.

I'm tempted to try that again - the box is a testsystem anyway and I'm 
curious if I can reprodue this "media format corrupted" state to see if 
the --wait option does anything.

Thanks for the prompt reply!
Christian.
-- 
BOFH excuse #287:

Telecommunications is downshifting.
