From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 09 Sep 2005 13:15:21 -0400
Message-ID: <4321C329.8030401@adaptec.com>
References: <Pine.LNX.4.44L0.0509081330530.5768-100000@iolanthe.rowland.org> <4320D066.5090806@adaptec.com> <4321C190.8090106@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6815 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030265AbVIIRPc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 13:15:32 -0400
In-Reply-To: <4321C190.8090106@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On 09/09/05 13:08, Stefan Richter wrote:
> Luben Tuikov wrote:
> 
>>Think about this:
>>	EH is function of scsi_host.
> 
> 
> The host does not use the EH. The EH uses the host.

That's exactly what my statement above means:

	F(scsi_host) = EH

>>	You can define YOUR OWN EH! in usb storage, which you control!
> 
> 
> There are a few hotpluggable low-level providers besides usb-storage.

Ok.

	Luben

