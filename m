From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mpt2sas: bug in disk ordering?
Date: Fri, 13 May 2011 14:09:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105131406320.20305@uplift.swm.pp.se>
References: <BANLkTi=SsdjeHJOU_we+kZMgM0qm7eaVjg@mail.gmail.com> <BANLkTikmS3ytn2MNczbvRinvwk4M-ba90g@mail.gmail.com> <B2FD678A64EAAD45B089B123FDFC3ED70157F7BB82@inbmail01.lsi.com> <BANLkTinqCmZzc2E7G1-W0qB-p8domw4KYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:44577 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150Ab1EMMJp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2011 08:09:45 -0400
In-Reply-To: <BANLkTinqCmZzc2E7G1-W0qB-p8domw4KYA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Fri, 13 May 2011, Caspar Smit wrote:

> I am used to the fact that all disks in a chassis are ordered in linux 
> according to the slot numbers on the chassis, this is to ensure a 
> reliable RAID setup so that /dev/sdb for instance is always in a certain 
> slot in the chassis. So far I only used lsi 3081e-r controllers and 
> these always gave me solid and reliable disk numbering. If this goes 
> random, how am i supposed to keep track which disk is where in the 
> chassis?

This has been discussed extensively before. There is no way to do it the 
way you want to. Personally, I label the serial number on the front of the 
drive cage and use that for tracking (together with smartctl).

Drive naming is not deterministic in linux as said before, and the quicker 
you accept this try to find other ways you're comfortable with that solves 
your operational problem, the less pain you will be in.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
