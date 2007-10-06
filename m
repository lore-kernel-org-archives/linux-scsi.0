From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: generating a Linux WWN?
Date: Sat, 06 Oct 2007 10:33:17 -0500
Message-ID: <1191684797.3338.31.camel@localhost.localdomain>
References: <1191622146.3475.51.camel@localhost.localdomain>
	 <20071005.151131.125883267.davem@davemloft.net>
	 <1191622488.3475.54.camel@localhost.localdomain>
	 <20071005.151711.112302061.davem@davemloft.net>
	 <1191679870.3338.17.camel@localhost.localdomain>
	 <47079D64.3070000@garzik.org>
	 <1191683096.3338.29.camel@localhost.localdomain>
	 <4707A854.1080309@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35036 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757393AbXJFPdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Oct 2007 11:33:19 -0400
In-Reply-To: <4707A854.1080309@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On Sat, 2007-10-06 at 11:23 -0400, Jeff Garzik wrote:
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

OK, give me your use case.

James


