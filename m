From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Sat, 06 Oct 2007 10:36:20 -0400
Message-ID: <47079D64.3070000@garzik.org>
References: <1191622146.3475.51.camel@localhost.localdomain>	 <20071005.151131.125883267.davem@davemloft.net>	 <1191622488.3475.54.camel@localhost.localdomain>	 <20071005.151711.112302061.davem@davemloft.net> <1191679870.3338.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56323 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbXJFOgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Oct 2007 10:36:40 -0400
In-Reply-To: <1191679870.3338.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Miller <davem@davemloft.net>, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> My problem with auto generated is that it's provably impossible to
> generate globally unique numbers for WWNs without some internal source
> of uniqueness (I know sparcs have this in their serial number, but most
> PCs unfortunately don't).
> 
> I know the auto generated number can be statistically reasonably unique,
> but sysadmins are lazy people.  If they run into this problem, they'll
> take the knob with the on/off switch rather than the think about the
> problem and specify the full WWN; and then, being busy people, they'll
> forget about it as "problem solved".  When they do this, statistically
> (and probably years later) there will be a cluster reboot where the
> entire SAN simply collapses and no-one knows why ... the poor SAN
> administrator will likely spend weeks working out the problem is.

Why, if we give lazy administrators root access, that's all they'll use, 
and they will just think "problem solved" until a serious security issue 
arises that takes down the cluster.

See how silly and un-Linux that logic is?  In Linux, the admin has the 
power to make stupid decisions -- or to make informed decisions that 
disagree your rigid "an admin should never do that" line of thought. 
It's their hardware.

You're also using the 1% case of a 1% case of a 1% case to argue against 
a feature that is useful in making things Just Work(tm).

	Jeff


