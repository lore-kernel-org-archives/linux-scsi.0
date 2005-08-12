From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 09:14:35 -0400
Message-ID: <1123852475.5546.22.camel@localhost.localdomain>
References: <1123799468.5546.81.camel@localhost.localdomain>
	 <1123830899.3218.15.camel@laptopd505.fenrus.org>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:7043 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S1751170AbVHLNOq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 09:14:46 -0400
In-Reply-To: <1123830899.3218.15.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2005-08-12 at 09:14 +0200, Arjan van de Ven wrote:
> On Thu, 2005-08-11 at 18:31 -0400, Ming Zhang wrote:
> > I have this eth1 and aic7xxx share 1 interrupt thus have impact on
> > performance, anyway i can change it? thx!
> 
> realistically, either you need to find a bios setting tweak, or you need
> to move one of the two to a different pci slot in the machine.
> 

i could not find any bios setting in the bios. it is a dell sc420. i
will try to move card around and see what happen. thx!


> 
> (Not that it's a big problem, sharing irqs on a pci system isn't too big
> a deal)
> 

i use it as my iscsi testbed so the sole activities are disk&network.
that is why i am worrying about it.

do you think it is ok to share? i think at least kernel need to find 1
irq handler to process the handler, then it have 1/2 chance (roughly
assume 1 network interrupt corresponding to 1 storage io interrupt, of
course this is not true in reality) to find that this is not the right
one and then reload another handler? i guess this will be critical when
# is huge like this. (i ran might 10 minutes with iometer on an iscsi
target.)

16:    1330261          0   IO-APIC-level  eth1, aic7xxx



Ming


