From: Nick Warne <nick@ukfsn.org>
Subject: Re: [PATCH] Fixup KERN_INFO in tmscsim.c
Date: Sun, 17 Aug 2008 09:43:20 +0100
Message-ID: <20080817094320.6f8c3812@sauron.linicks.net>
References: <20080815121045.48ca37e4@sauron.linicks.net>
	<Pine.LNX.4.64.0808152202440.7852@axis700.grange>
	<20080816090654.4a5188e2@sauron.linicks.net>
	<Pine.LNX.4.64.0808162351560.6275@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:43465 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbYHQInX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 04:43:23 -0400
In-Reply-To: <Pine.LNX.4.64.0808162351560.6275@axis700.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi Guennadi,

On Sun, 17 Aug 2008 00:00:44 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> From: Nick Warne <nick@ukfsn.org>
> 
> Multiline kernel messages should contain a priority in every line, 
> besides, some log daemons represent a tabulator as "^I", fix both
> these issues.
> 
> Signed-off-by: Nick Warne <nick@ukfsn.org>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

> Nick, I took the liberty to reformat your Sob and to replace the tab
> in your patch with spaces - as was in my previous reply to you. Hope,
> you don't mind:-)

No not at all - I saw just as I clicked *send* I buggered up the
Signed-off-by line... and also I didn't realise they was spaces - I
thought you changed to a real whitespace TAB rather than \t (but I
guess there is no difference on the way the lines get parsed).

Anyway, as an aside, my syslogd/klogd still shows whitespace TAB as ^I,
so I haven't clue what if going on there.

Also, now I have trimmed up my kernel build for new box, I don't see
these drivers anyway now... but at least it was caught.

Nick

> diff -u linux-2.6.26.y/drivers/scsi/tmscsim.cORIG
> linux-2.6.26.y/drivers/scsi/tmscsim.c ---
> linux-2.6.26.y/drivers/scsi/tmscsim.cORIG	2008-08-15
> 10:30:47.000000000 +0100 +++
> linux-2.6.26.y/drivers/scsi/tmscsim.c	2008-08-16
> 08:45:43.000000000 +0100 @@ -2573,8 +2573,8 @@ static int __init
> dc390_module_init(void) { if (!disable_clustering)
> -		printk(KERN_INFO "DC390: clustering now enabled by
> default. If you get problems load\n"
> -		       "\twith \"disable_clustering=1\" and report
> to maintainers\n");
> +		printk(KERN_INFO "DC390: clustering now enabled by
> default. If you get problems load\n");
> +		printk(KERN_INFO "       with
> \"disable_clustering=1\" and report to maintainers\n"); 
>  	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
>  		tmscsim[0] = 7;
> 


-- 
Free Software Foundation Associate Member 5508
