From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Thu, 12 Aug 2004 20:38:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092307081.26432.0.camel@gaston>
References: <4119611D.60401@optonline.net>
	 <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net>
	 <1092231462.2087.3.camel@mulgrave> <1092267400.2136.24.camel@gaston>
	 <20040812074520.GE29466@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:7657 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S268504AbUHLKn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 06:43:27 -0400
In-Reply-To: <20040812074520.GE29466@elf.ucw.cz>
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Nathan Bryant <nbryant@optonline.net>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>


> Hmm, and it can not be handled by "just remember why you were
> suspended", because it is one suspend, two resumes...
> 
> Yes, I agree that argument will be usefull. Just who does all the
> driver updating? ;-).

At this point, no driver cares, so it's just a matter of fixing the
prototypes, I'll leave that to somebody more familiar with sed :)

Ben.


