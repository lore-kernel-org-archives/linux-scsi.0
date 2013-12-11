From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 2/2] pm80xx : Fixed return value issue
Date: Wed, 11 Dec 2013 11:47:00 -0800
Message-ID: <1386791220.2109.0.camel@dabdike.int.hansenpartnership.com>
References: <1386651698-4331-1-git-send-email-Viswas.G@pmcs.com>
	 <52A89480.1010104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44682 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab3LKTrJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Dec 2013 14:47:09 -0500
In-Reply-To: <52A89480.1010104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Viswas G <Viswas.G@pmcs.com>, linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com

On Wed, 2013-12-11 at 17:36 +0100, Tomas Henzl wrote:
> On 12/10/2013 06:01 AM, Viswas G wrote:
> > pm80xx_get_gsm_dump() was returning "1" in error case
> > instead of negative error value.
> >
> > Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> > Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
> > Acked-by: TomasHenzl <thenzl@redhat.com>
> 
> Hi Viswas,
> 
> I've ack-ed a different patch before, so I don't think you should add that acked-by line.
> The V2 patch is fine for me too, so again -
> Acked-by: Tomas Henzl <thenzl@redhat.com>

Actually, it can't be acked-by; that's for maintainers agreeing to
patches not via them ... I assume it should be reviewed by?

James


