From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Wed, 11 Aug 2004 12:43:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <411A4C9D.4040902@optonline.net>
References: <4119611D.60401@optonline.net> <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net> <1092231462.2087.3.camel@mulgrave> <1092237664.19009.23.camel@localhost.localdomain> <1092241693.1590.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pegasus.allegientsystems.com ([208.251.178.236]:30726 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S268105AbUHKQnK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 12:43:10 -0400
In-Reply-To: <1092241693.1590.1.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

James Bottomley wrote:
> On Wed, 2004-08-11 at 10:21, Alan Cox wrote:
> 
>>In addition we are not doing SCSI target so multi-initiator is ok.
>>One question James - what are the rules for power management with
>>SCSI when we provide termpwr to a shared bus ?

Well there are (at least) two reasons to do shared bus: IP over SCSI and 
cluster filesystems. At least for cluster filesystems I think the answer 
is "don't suspend your machine" for the foreseeable future - what 
happens if your machine goes to sleep while holding cluster FS locks, 
etc. I doubt any CFS vendors are going to bother to support this any 
time soon, since it's a HA/server feature and power management is really 
a desktop/laptop feature.
