From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 12/14] scsi: use printk_once
Date: Tue, 11 Aug 2009 09:49:38 -0700
Message-ID: <1250009378.8895.425.camel@Joe-Laptop.home>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	 <1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
	 <1250008813.4301.55.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4278 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbZHKQtl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 12:49:41 -0400
In-Reply-To: <1250008813.4301.55.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Tue, 2009-08-11 at 11:40 -0500, James Bottomley wrote:
> On Sun, 2009-08-09 at 21:54 +0200, Marcin Slusarz wrote:
> > --- a/drivers/scsi/cxgb3i/cxgb3i_init.c
> > +++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
> > @@ -43,12 +43,7 @@ static struct cxgb3_client t3c_client = {
> >   */
> >  static void open_s3_dev(struct t3cdev *t3dev)
> >  {
> > -	static int vers_printed;
> > -
> > -	if (!vers_printed) {
> > -		printk(KERN_INFO "%s", version);
> > -		vers_printed = 1;
> > -	}
> > +	printk_once(KERN_INFO "%s", version);
> 
> There's really no point to this beyond code churn.  Both patterns are
> correct uses so conversion buys us nothing.

Standards are for hacks.  Stasis is the best policy.
Using patterns isn't worth the electron movement.
Code shortening and readability?  Humbug.


