From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: +
	scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch added to -mm
	tree
Date: Wed, 05 Mar 2008 18:27:27 -0600
Message-ID: <1204763247.3047.111.camel@localhost.localdomain>
References: <200803060016.m260Giml029428@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40366 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbYCFA1a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 19:27:30 -0500
In-Reply-To: <200803060016.m260Giml029428@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, harvey.harrison@gmail.comharvey.harrison@gmail.com


On Wed, 2008-03-05 at 16:16 -0800, akpm@linux-foundation.org wrote:
> The patch titled
>      scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes
> has been added to the -mm tree.  Its filename is
>      scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> ERROR: need space after that ',' (ctx:VxV)
> #66: FILE: drivers/scsi/ch.c:742:
> +		memset(ch_cmd,0,sizeof(ch_cmd));
>  		             ^
> 
> ERROR: need space after that ',' (ctx:VxV)
> #66: FILE: drivers/scsi/ch.c:742:
> +		memset(ch_cmd,0,sizeof(ch_cmd));
>  		               ^
> 
> ERROR: need space after that ',' (ctx:VxV)
> #70: FILE: drivers/scsi/ch.c:746:
> +			    ch_elem_to_typecode(ch,elem);
>  			                          ^
> 
> total: 3 errors, 0 warnings, 55 lines checked
> 
> ./patches/scsi-chc-fix-shadowed-variable-warnings.patch has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> Please run checkpatch prior to sending patches
> 
> Cc: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/ch.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes drivers/scsi/ch.c
> --- a/drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes
> +++ a/drivers/scsi/ch.c
> @@ -739,11 +739,11 @@ static long ch_ioctl(struct file *file,
>  		mutex_lock(&ch->lock);
>  
>  	voltag_retry:
> -		memset(ch_cmd,0,sizeof(ch_cmd));
> +		memset(ch_cmd, 0, sizeof(ch_cmd));
>  		ch_cmd[0] = READ_ELEMENT_STATUS;
>  		ch_cmd[1] = (ch->device->lun << 5) |
>  			    (ch->voltags ? 0x10 : 0) |
> -			    ch_elem_to_typecode(ch,elem);
> +			    ch_elem_to_typecode(ch, elem);
>  		ch_cmd[2] = (elem >> 8) & 0xff;
>  		ch_cmd[3] = elem        & 0xff;
>  		ch_cmd[5] = 1;

Please stop.  I'm not taking whitespace patches ... one per file no
less.  I take whitespace and other cleanups as part of real driver
updates only.

James


