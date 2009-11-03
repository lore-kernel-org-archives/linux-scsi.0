From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: tmscsim: Missing parentheses in dc390_init_hw()?
Date: Tue, 03 Nov 2009 17:07:59 -0600
Message-ID: <1257289679.2454.23.camel@mulgrave.site>
References: <4AF0B4E1.2030407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZKCXH7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 18:07:59 -0500
In-Reply-To: <4AF0B4E1.2030407@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-11-03 at 23:55 +0100, Roel Kluin wrote:
> Same oddness, are there parentheses missing here?
> 
> Thanks, Roel
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 9a42734..25e6d63 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -2408,8 +2408,8 @@ static void __devinit dc390_init_hw(struct dc390_acb *pACB, u8 index)
>  
>  	/* Negation */
>  	DC390_write8(CtrlReg4, pACB->glitch_cfg | /* glitch eater */
> -		(dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION) ?
> -		 NEGATE_REQACKDATA : 0);
> +		((dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION) ?
> +		 NEGATE_REQACKDATA : 0));

This one looks more possible ... but given it's hw init, the original
meaning is also possible ... and supported by the fact that the hw
works.

James


