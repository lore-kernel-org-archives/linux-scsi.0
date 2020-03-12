Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07956C1975A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 10:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA236206FA
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 10:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="zQX0ru89"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCLKLr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:11:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40416 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgCLKLq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 06:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=w/IhOjRvXC482b0KYkKadqEdR2iC079En/fPLUwhOKA=; b=zQX0ru89FGMsRzrWSfb1/f9Sx
        58KjHkMU8xb9ife2j0YCZEP6uKjBW9qqUf7GZa1VLXn/G2O0gLiqAh3PGq9lSvKs8YXoDzS2RxfDb
        RCptmxmBe+q0a8VQvqBItrRhf96aBtF4u4ws2M/4S9GIgmbXDs9TRAWalsFAwSj+WcrKDfAB0DGvi
        MpYnoDO4fRbMuJer11qOtU5WskxbvCuEDDoTQkejLesgwqD5JorY4XUljARGZaF5UnBtDcnd1x/oW
        bs3tDGtB6bzFsygvHfjpEZTXZRA6cW0hsVWYUyIpvWVMq34JSON8HBMjX3wJcFJ0NgyQV3EuL2EaH
        jxI7mzwmA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35400)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jCKoO-0000Wi-FR; Thu, 12 Mar 2020 10:11:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jCKoM-0006Eu-Ai; Thu, 12 Mar 2020 10:11:30 +0000
Date:   Thu, 12 Mar 2020 10:11:30 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Joe Perches <joe@perches.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next 006/491] ARM/RISCPC ARCHITECTURE: Use fallthrough;
Message-ID: <20200312101130.GX25745@shell.armlinux.org.uk>
References: <cover.1583896344.git.joe@perches.com>
 <fb956ff22b89ac7a7f97489b29ecf13a32de8d06.1583896348.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb956ff22b89ac7a7f97489b29ecf13a32de8d06.1583896348.git.joe@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 09:51:20PM -0700, Joe Perches wrote:
> Convert the various uses of fallthrough comments to fallthrough;

And the point of what on the face of it seems to be useless churn is?

What compilers support this?

I'd check the gcc manual, but debian doesn't provide it.

> 
> Done via script
> Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/arm/mach-rpc/riscpc.c |  2 +-
>  drivers/scsi/arm/fas216.c  | 17 ++++++-----------
>  2 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/mach-rpc/riscpc.c b/arch/arm/mach-rpc/riscpc.c
> index ea2c842..d23970b 100644
> --- a/arch/arm/mach-rpc/riscpc.c
> +++ b/arch/arm/mach-rpc/riscpc.c
> @@ -46,7 +46,7 @@ static int __init parse_tag_acorn(const struct tag *tag)
>  	switch (tag->u.acorn.vram_pages) {
>  	case 512:
>  		vram_size += PAGE_SIZE * 256;
> -		/* Fall through - ??? */
> +		fallthrough;	/* ??? */
>  	case 256:
>  		vram_size += PAGE_SIZE * 256;
>  	default:
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index 6c68c230..bb18be 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -603,8 +603,7 @@ static void fas216_handlesync(FAS216_Info *info, char *msg)
>  		msgqueue_flush(&info->scsi.msgs);
>  		msgqueue_addmsg(&info->scsi.msgs, 1, MESSAGE_REJECT);
>  		info->scsi.phase = PHASE_MSGOUT_EXPECT;
> -		/* fall through */
> -
> +		fallthrough;
>  	case async:
>  		dev->period = info->ifcfg.asyncperiod / 4;
>  		dev->sof    = 0;
> @@ -916,8 +915,7 @@ static void fas216_disconnect_intr(FAS216_Info *info)
>  			fas216_done(info, DID_ABORT);
>  			break;
>  		}
> -		/* else, fall through */
> -
> +		fallthrough;
>  	default:				/* huh?					*/
>  		printk(KERN_ERR "scsi%d.%c: unexpected disconnect in phase %s\n",
>  			info->host->host_no, fas216_target(info), fas216_drv_phase(info));
> @@ -1413,8 +1411,7 @@ static void fas216_busservice_intr(FAS216_Info *info, unsigned int stat, unsigne
>  	case STATE(STAT_STATUS, PHASE_DATAOUT): /* Data Out     -> Status       */
>  	case STATE(STAT_STATUS, PHASE_DATAIN):  /* Data In      -> Status       */
>  		fas216_stoptransfer(info);
> -		/* fall through */
> -
> +		fallthrough;
>  	case STATE(STAT_STATUS, PHASE_SELSTEPS):/* Sel w/ steps -> Status       */
>  	case STATE(STAT_STATUS, PHASE_MSGOUT):  /* Message Out  -> Status       */
>  	case STATE(STAT_STATUS, PHASE_COMMAND): /* Command      -> Status       */
> @@ -1426,8 +1423,7 @@ static void fas216_busservice_intr(FAS216_Info *info, unsigned int stat, unsigne
>  	case STATE(STAT_MESGIN, PHASE_DATAOUT): /* Data Out     -> Message In   */
>  	case STATE(STAT_MESGIN, PHASE_DATAIN):  /* Data In      -> Message In   */
>  		fas216_stoptransfer(info);
> -		/* fall through */
> -
> +		fallthrough;
>  	case STATE(STAT_MESGIN, PHASE_COMMAND):	/* Command	-> Message In	*/
>  	case STATE(STAT_MESGIN, PHASE_SELSTEPS):/* Sel w/ steps -> Message In   */
>  	case STATE(STAT_MESGIN, PHASE_MSGOUT):  /* Message Out  -> Message In   */
> @@ -1581,8 +1577,7 @@ static void fas216_funcdone_intr(FAS216_Info *info, unsigned int stat, unsigned
>  			fas216_message(info);
>  			break;
>  		}
> -		/* else, fall through */
> -
> +		fallthrough;
>  	default:
>  		fas216_log(info, 0, "internal phase %s for function done?"
>  			"  What do I do with this?",
> @@ -1964,7 +1959,7 @@ static void fas216_kick(FAS216_Info *info)
>  	switch (where_from) {
>  	case TYPE_QUEUE:
>  		fas216_allocate_tag(info, SCpnt);
> -		/* fall through */
> +		fallthrough;
>  	case TYPE_OTHER:
>  		fas216_start_command(info, SCpnt);
>  		break;
> -- 
> 2.24.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
