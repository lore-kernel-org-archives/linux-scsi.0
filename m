From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: ISCSI
Date: Sun, 12 Dec 2004 13:55:22 -0500
Message-ID: <1102877722.3012.100.camel@localhost.localdomain>
References: <200412121808.iBCI8O901869@www.watkins-home.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:32212 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S261866AbULLSz0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Dec 2004 13:55:26 -0500
In-Reply-To: <200412121808.iBCI8O901869@www.watkins-home.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

i suggest u to use UNH iSCSI + SCST. it provides a bypass mode which fit
you needs. IET will support a bypass interface later.

Ming

On Sun, 2004-12-12 at 13:08, Guy wrote:
> I have a SCSI tape drive on my Linux system.  I want to use the tape drive
> from another system with another (evil) OS.  I have found more than 1 source
> forge project related to ISCSI.  These projects seem to only talk about disk
> access (SAN), not tape access.  I can't determine which I should use, if
> any.
> 
> Does anyone know which is best?
> I have kernel 2.4.28, but would be willing to attempt an upgrade if needed.
> 
> Thanks,
> Guy
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

