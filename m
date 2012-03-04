From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] SCSI st: expand ability to write immediate filemarks
Date: Sun, 4 Mar 2012 22:09:41 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1203042208460.5050@kai.makisara.local>
References: <4F4FDEDD.1000701@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([62.142.117.202]:38955 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab2CDUJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2012 15:09:53 -0500
In-Reply-To: <4F4FDEDD.1000701@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012, Lee Duncan wrote:

> The st tape driver recently added the MTWEOFI ioctl, which writes
> a tape filemark (EOF), like the MTWEOF ioctl, except that MTWEOFI
> returns immediately. This makes certain applications, like backup
> software, run much more quickly on buffered tape drives.
> 
> Since legacy applications do not know about this new MTWEOFI ioctl,
> this patch adds a new ioctl option that tells the st driver to return
> immediately when writing an EOF (i.e. a filemark). This new flag
> is much like the existing flag that tells the st driver to perform
> writes (and certain other IOs) immediately, but this new flag only
> applies to writing EOFs.
> 
> This new feature is controlled via the MTSETDRVBUFFER ioctl, using
> the newly-defined MT_ST_NOWAIT_EOF flag.
> 
> Use of this new feature is displayed via the sysfs tape "options"
> attribute.
> 
> The st documentation was updated to mention this new flag, as well
> as the problems that can occur from using it.
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>

> ---
>  Documentation/scsi/st.txt |    4 ++++
>  drivers/scsi/st.c         |   21 ++++++++++++++++++---
>  drivers/scsi/st.h         |    1 +
>  include/linux/mtio.h      |    1 +
>  4 files changed, 24 insertions(+), 3 deletions(-)

Thanks,
Kai

