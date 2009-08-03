From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI git trees
Date: Mon, 03 Aug 2009 18:57:05 +0000
Message-ID: <1249325826.3943.207.camel@mulgrave.site>
References: <1248887256.3900.78.camel@mulgrave.site>
	 <19063.9181.620137.814464@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50345 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931AbZHCS5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 14:57:09 -0400
In-Reply-To: <19063.9181.620137.814464@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

On Mon, 2009-08-03 at 13:52 -0400, John Stoffel wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> It seems I got unsubscribed from linux-scsi last week while I was on
> James> holiday and I've likely missed a slew of patches, it seems like an
> James> appropriate time to remind everyone how the SCSI trees work.
> 
> James> ---
> 
> James> There are two git based scsi trees:
> 
> James> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> James> called the scsi-misc tree for patches being collected for the
> James> next merge window.  And
> 
> I don't see my patch to block/Kconfig to make BLK_DEV_BSG be enabled
> by default.  Is this going to be pushed for 2.6.32-rc1 when the merge
> window opens up?  
> 
> I've attached the patch, just to make sure.  Let me know if I should
> send it in properly.
> 
> Thanks!
> John
> 
> 
> Make Block Layer SG support v4 the default, since recent udev versions
> depend on this to access serial numbers and other low level info
> properly.
> 
> This should be backported to older kernels as well, since most distros
> have
> enabled this for a long time.
> 
> Signed-off-by: John Stoffel <john@stoffel.org>
> ---
>  block/Kconfig |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index e7d1278..55bbefc 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig

Actually, this one isn't really SCSI; it's block (Jens cc'd).  It's Jens
call on the backport, but my feeling is that removing a feature from
experimental is really an enhancement not a bug fix, so it's not really
eligible under the backport rules.

James


