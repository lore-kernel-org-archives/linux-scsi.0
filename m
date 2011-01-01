From: Christian Schmidt <charlie@digadd.de>
Subject: Re: Linux support for the LSI SAS8208ELP
Date: Sat, 01 Jan 2011 18:32:18 +0100
Message-ID: <4D1F6522.3050103@digadd.de>
References: <4D1E0831.8090602@digadd.de> <20101231175200.GA32652@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:58265 "EHLO mx1.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752923Ab1AARc1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Jan 2011 12:32:27 -0500
In-Reply-To: <20101231175200.GA32652@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

Hi Matthew,

On 12/31/2010 06:52 PM, Matthew Wilcox wrote:
> On Fri, Dec 31, 2010 at 05:43:29PM +0100, Christian Schmidt wrote:
>> Since LSI seems to only provide closed source drivers for far obsolete
>> and limited "enterprise" distribution kernels I'd suggest the inclusion
>> of the PCI IDs into the kernel.
> 
> http://marc.info/?l=linux-scsi&m=129019864003449&w=2
> 
> (ok, 0x55 vs 0x59, but dollars-to-doughnuts it's the same 'problem')

Thanks for the link. On my mainboard it wasn't a BIOS setting but a
jumper that changed the mode.

Regards,
Christian
