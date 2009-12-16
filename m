From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: how to recover from "medium format corrupted"?
Date: Tue, 15 Dec 2009 21:18:31 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912152104090.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912140158580.2915@bogon.housecafe.de> <4B264C83.4080009@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZLPFSi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 00:18:38 -0500
In-Reply-To: <4B264C83.4080009@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 14 Dec 2009 at 15:32, Douglas Gilbert wrote:
> Could you try the '--wait' option on the sg_format?

OK, I was curious enough to try this again: interrupt a FORMAT command, 
now the disk responds with ASC=0x31 ASCQ=0x0 again. However, the --wait 
option (sg_format version: 1.17 20090324) doesn't do anything:

v40z1# sg_format --format --wait -vvv /dev/sdb 
open /dev/sdb with flags=0x802
    inquiry cdb: 12 00 00 00 24 00 
      duration=0 ms
    SEAGATE   ST373307LC        0007   peripheral_type: disk [0x0]
      PROTECT=0
    mode sense (10) cdb: 5a 00 01 00 00 00 00 00 fc 00 
      duration=0 ms
sense buffer empty
    requested 252 bytes but got 0 bytes
MODE SENSE (10) command failed


I can leave the disk in this state if you want to play around some more 
and will bring back the disk in a usable state in a few days then.

Thanks,
Christian.
-- 
BOFH excuse #403:

Sysadmin didn't hear pager go off due to loud music from bar-room speakers.
