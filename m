From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Wed, 11 Aug 2004 16:50:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <411A86AC.6070403@optonline.net>
References: <4119611D.60401@optonline.net> <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net> <20040811201944.GA1550@openzaurus.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from odin.allegientsystems.com ([208.251.178.227]:47626 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S268178AbUHKUux (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 16:50:53 -0400
In-Reply-To: <20040811201944.GA1550@openzaurus.ucw.cz>
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, jgarzik@pobox.com

Pavel Machek wrote:

> No, I do not need PIO. I'll probably need host
> controller support, too, but even w/o it it should
> work acceptably. Thanks for the answers.

Well, take note of what James wrote. We do guarantee that there will be 
no further user-initiated disk activity after generic_scsi_suspend. (For 
the disk but not the rest of the bus.) This doesn't apply to 
ioctl's/special requests but as James has rightly pointed out this is 
probably not an issue for realistic intents and purposes. It may 
actually be an advantage.
