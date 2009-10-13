From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
Date: Tue, 13 Oct 2009 09:45:30 -0700
Message-ID: <4AD4AEAA.2080209@goop.org>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>	<20091002004725.GP3958@sequoia.sous-sol.org>	<1254789028.15233.54.camel@ank32.eng.vmware.com> <1255444557.2855.95.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from claw.goop.org ([74.207.240.146]:35463 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbZJMQqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 12:46:08 -0400
In-Reply-To: <1255444557.2855.95.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: akataria@vmware.com, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, Roland Dreier <rdreier@cisco.com>, Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Chris Wright <chrisw@sous-sol.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Daniel Walker <dwalker@fifo99.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Robert Love <robert.w.love@intel.com>, Andrew Morton <akpm@linux-foundation.org>

On 10/13/09 07:35, James Bottomley wrote:
>> Yep, below is a patch with the rename, the driver is now called
>> vmw_pvscsi. Do let me know if you have any other comments. Thanks.
>>     
> I'm still curious to know what the 'p' in the name stands for.  Surely
> this is a fully virtual driver, not a paravirtual one?
>   

I would assume that "pv" does stand for paravirtual.  The terminology is
a bit screwy: "fully virtualized" means that the device looks like a
real hardware device that is being emulated.  "Paravirtualized" means
that it is a completely virtual device which isn't an emulation of
anything; the guests know this this and talk to it accordingly.

    J

