From: Mark Lord <lkml@rtr.ca>
Subject: Re: sg regression in 2.6.16-rc5
Date: Wed, 01 Mar 2006 13:32:10 -0500
Message-ID: <4405E8AA.1090803@rtr.ca>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net> <20060301083824.GA9871@merlin.emma.line.org> <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:60854 "EHLO mail.rtr.ca")
	by vger.kernel.org with ESMTP id S1750775AbWCASby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 13:31:54 -0500
In-Reply-To: <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Matthias Andree <matthias.andree@gmx.de>, Douglas Gilbert <dougg@torque.net>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Linus Torvalds wrote:
> 
> On Wed, 1 Mar 2006, Matthias Andree wrote:
>> On Tue, 28 Feb 2006, Douglas Gilbert wrote:
>>
>>> You can stop right there with the 1 MB reads. Welcome
>>> to the new, blander sg driver which now shares many
>>> size shortcomings with the block subsystem.
>> What is the reason to break user-space applications like this?
> 
> Did you read the whole thread? It was a low-level SCSI driver issue, where 
> nothing broke user space, but the command was just fed to the drive 
> differently, which then hit a limit in the driver.

Will this break major applications like CD/DVD rippers,
DVD players, etc.. which read LARGE blocks at a time?

If not, then good!
