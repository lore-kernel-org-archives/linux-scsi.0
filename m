From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH v10 0/9] More device removal fixes
Date: Wed, 8 May 2013 09:58:07 -0400
Message-ID: <20130508095807.2d841fb5@jlaw-desktop.mno.stratus.com>
References: <516188E5.1040008@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:36234 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab3EHOBv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 10:01:51 -0400
In-Reply-To: <516188E5.1040008@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 07 Apr 2013 16:55:33 +0200
Bart Van Assche <bvanassche@acm.org> wrote:

> Fix a few issues that can be triggered by removing a device:
> - Fix a race between starved list processing and device removal.
> - Avoid that a SCSI LLD callback can get invoked after
>    scsi_remove_host() finished.
> - Speed up device removal by stopping error handling as soon as
>    the SHOST_DEL or SHOST_DEL_RECOVERY state has been reached.
> - Save and restore the host_scribble field during error handling.
> 
> These patches have been tested on top of kernel v3.9-rc5.

Hi Bart,

I tested the patchset against 3.9 and ran surprise HBA device removals
during device initialization (3sec, 6sec, 12sec) while running IO out
to a multipath LUN and an MD RAID1 SAS pair.  No warnings in the logs
and everything looks consistent this morning.

Regards,

-- Joe
