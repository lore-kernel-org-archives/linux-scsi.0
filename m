From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: generating a Linux WWN?
Date: Mon, 8 Oct 2007 11:42:18 -0700 (PDT)
Message-ID: <184001.11168.qm@web31805.mail.mud.yahoo.com>
References: <4707A854.1080309@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:31274 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753932AbXJHSmT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Oct 2007 14:42:19 -0400
In-Reply-To: <4707A854.1080309@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Miller <davem@davemloft.net>, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

--- Jeff Garzik <jeff@garzik.org> wrote:
> James Bottomley wrote:
> > If you remember Rusty's guide to interfaces, this is a level 14 easy to
> > misuse interface: "The obvious use is wrong"; since the obvious use is
> > to put it in module parameters and have the problem go away (for
> > now ...).  Actually, I could be harsher and say it's level 17 "There's
> > no correct use" because statistically every time you use it, you expose
> > yourself to potential duplicate WWNs.
> 
> 
> Now that you have said "there's no correct use" you have managed to 
> logic yourself into silly-land.
> 
> That is utterly specious logic when duplicate WWNs are quite unlikely, 
> and furthermore -- as demonstrated by use in network drivers -- use of 
> the feature itself is not the common case.
> 
> Field experience directly contradicts this entire line of reasoning.

You have SAS SAN's field experience?

   Luben

