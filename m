From: Michael Reed <mdr@sgi.com>
Subject: Re: generating a Linux WWN?
Date: Mon, 08 Oct 2007 10:41:04 -0500
Message-ID: <470A4F90.3030901@sgi.com>
References: <1191679870.3338.17.camel@localhost.localdomain>	<47079D64.3070000@garzik.org>	<1191683096.3338.29.camel@localhost.localdomain> <20071006.194836.66070475.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37080 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751503AbXJHPlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Oct 2007 11:41:11 -0400
In-Reply-To: <20071006.194836.66070475.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@SteelEye.com, jeff@garzik.org, ltuikov@yahoo.com, lydianconcepts@gmail.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org



David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Sat, 06 Oct 2007 10:04:55 -0500
> 
>> If you remember Rusty's guide to interfaces, this is a level 14 easy to
>> misuse interface: "The obvious use is wrong"; since the obvious use is
>> to put it in module parameters and have the problem go away (for
>> now ...).  Actually, I could be harsher and say it's level 17 "There's
>> no correct use" because statistically every time you use it, you expose
>> yourself to potential duplicate WWNs.
> 
> Every time you use GIT you expose yourself to potential duplicate SHAs
> which will corrupt the tree.
> 
> This argument borders on lunacy, give it up :-)

As long as two systems on the same SAN are quite unlikely to wind up with
the same WWN.  override_wwn=5000000000000001 comes to mind.  Two months
later, another admin does the same thing to another system.  As Jeff has
pointed out, there really should be some method in place that allows for
some randomness in the wwn.  (Other than fixing the broken hardware. :)
Handing the admins the rope doesn't mean we want to see it around their necks!

And, while I'm thinking about it, whatever implementation is chosen, doesn't
it need to allow for the targeting of a particular sas host adapter and
perhaps even a particular sas port on the adapter?

Mike

