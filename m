From: egi <pfammatter-egi@swissonline.ch>
Subject: Re: LSIFC909 problem
Date: Tue, 23 Oct 2007 19:31:26 +0200
Message-ID: <fflb5f$ik6$1@ger.gmane.org>
References: <20071022161804.GB27248@parisc-linux.org> <664A4EBB07F29743873A87CF62C26D70A87BF1@NAMAIL4.ad.lsil.com> <20071022164255.GC27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53652 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXJWRfJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Oct 2007 13:35:09 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IkNeg-00045h-7e
	for linux-scsi@vger.kernel.org; Tue, 23 Oct 2007 17:35:02 +0000
Received: from 84-73-220-234.dclient.hispeed.ch ([84.73.220.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 23 Oct 2007 17:35:02 +0000
Received: from pfammatter-egi by 84-73-220-234.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 23 Oct 2007 17:35:02 +0000
In-Reply-To: <20071022164255.GC27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Oct 22, 2007 at 10:33:41AM -0600, Moore, Eric wrote:
>> On Monday, October 22, 2007 10:18 AM,  Matthew Wilcox wrote:
>>> Sounds like we need a new driver written to support the FC909 then.
>>> Unless we could pretend the FC909 is a parallel scsi card or something
>>> ... that wasn't quite clear from Michael's mail.
>>>
>> ok, are you suggesting for FC909 we call scsi_scan_host, else chips we
>> "hook into transport layer"?
> 
> Yes.  That reminds me, I need to convert fusion to the parallel scanning
> regime.  I haven't forgotten our conversation at OLS2006.
> 
>> The way I understood from Stephen Shirron, is the FC909 is using mpi
>> version 1.0, and all the other FC cards are on mpi version 1.2 or 1.5.
>> The mpi defines the interface between driver and firmware.   The older
>> mpi version 1.0 is missing feature needed for the FC transport to work.
> 
> That sounds plausible.
> 
Thank you a lot for your infos. You writes that this card isn't any more 
supported.
What's suspectfor me is why the fc909 is still listed on the Kconfig as 
supported controller. I request this lsi909 card 8 mnoth ago. This was a 
new card and the seller told me that this card was often sold and he had 
also a lot of this cards allways in his stock. (maybe i' m the first 
user of this card which shuold run with linux ;-) ..
You wrote any changes which must be done to support this card with the 
current kernel. Is this a lot of work for you?

