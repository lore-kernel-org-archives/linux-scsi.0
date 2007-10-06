From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Sat, 06 Oct 2007 11:23:00 -0400
Message-ID: <4707A854.1080309@garzik.org>
References: <1191622146.3475.51.camel@localhost.localdomain>	 <20071005.151131.125883267.davem@davemloft.net>	 <1191622488.3475.54.camel@localhost.localdomain>	 <20071005.151711.112302061.davem@davemloft.net>	 <1191679870.3338.17.camel@localhost.localdomain>	 <47079D64.3070000@garzik.org> <1191683096.3338.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59183 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575AbXJFPXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Oct 2007 11:23:16 -0400
In-Reply-To: <1191683096.3338.29.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Miller <davem@davemloft.net>, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> If you remember Rusty's guide to interfaces, this is a level 14 easy to
> misuse interface: "The obvious use is wrong"; since the obvious use is
> to put it in module parameters and have the problem go away (for
> now ...).  Actually, I could be harsher and say it's level 17 "There's
> no correct use" because statistically every time you use it, you expose
> yourself to potential duplicate WWNs.


Now that you have said "there's no correct use" you have managed to 
logic yourself into silly-land.

That is utterly specious logic when duplicate WWNs are quite unlikely, 
and furthermore -- as demonstrated by use in network drivers -- use of 
the feature itself is not the common case.

Field experience directly contradicts this entire line of reasoning.

	Jeff


