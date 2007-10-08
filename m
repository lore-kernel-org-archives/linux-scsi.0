From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: generating a Linux WWN?
Date: Mon, 8 Oct 2007 11:34:43 -0700 (PDT)
Message-ID: <962818.30064.qm@web31813.mail.mud.yahoo.com>
References: <47079D64.3070000@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:24433 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754793AbXJHSep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Oct 2007 14:34:45 -0400
In-Reply-To: <47079D64.3070000@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Miller <davem@davemloft.net>, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

--- Jeff Garzik <jeff@garzik.org> wrote:

> James Bottomley wrote:
> > My problem with auto generated is that it's provably impossible to
> > generate globally unique numbers for WWNs without some internal source
> > of uniqueness (I know sparcs have this in their serial number, but most
> > PCs unfortunately don't).
> > 
> > I know the auto generated number can be statistically reasonably unique,
> > but sysadmins are lazy people.  If they run into this problem, they'll
> > take the knob with the on/off switch rather than the think about the
> > problem and specify the full WWN; and then, being busy people, they'll
> > forget about it as "problem solved".  When they do this, statistically
> > (and probably years later) there will be a cluster reboot where the
> > entire SAN simply collapses and no-one knows why ... the poor SAN
> > administrator will likely spend weeks working out the problem is.
> 
> Why, if we give lazy administrators root access, that's all they'll use, 
> and they will just think "problem solved" until a serious security issue 
> arises that takes down the cluster.
> 
> See how silly and un-Linux that logic is?  In Linux, the admin has the 
> power to make stupid decisions -- or to make informed decisions that 
> disagree your rigid "an admin should never do that" line of thought. 
> It's their hardware.
> 
> You're also using the 1% case of a 1% case of a 1% case to argue against 
> a feature that is useful in making things Just Work(tm).

What he's arguing about is the _capability_ for a node in a SAN
to *(auto)generate* WWN and assign it to itself (at every
reboot, etc).  This is considered a _rogue_ node and *no* SAN
architect or admin will tolerate such a node.

The problem here is NOT the _capability_ to assign a WWN.
Admin does have the capability to assign (if missing) and/or
override (if present) a WWN currently with aic94xx driver.
This is fine.

The problem is "(auto)generate".  Think of SANs.

   Luben

