From: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Wed, 09 Sep 2009 19:11:34 -0500
Message-ID: <4AA84436.3050205@codemonkey.ws>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>	<4AA8177A.2020606@codemonkey.ws>	<1252533093.24633.40.camel@ank32.eng.vmware.com>	<4AA8284A.3010908@codemonkey.ws>	<20090909230854.GA4495@infradead.org> <4AA83B88.2020104@codemonkey.ws> <4AA84020.6040504@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:54563 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZIJALd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 20:11:33 -0400
In-Reply-To: <4AA84020.6040504@goop.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, LKML <linux-kernel@vger.kernel.org>, virtualization <virtualization@lists.linux-foundation.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com, Rolf Eike Beer <eike-kernel@sf-tec.de>

Jeremy Fitzhardinge wrote:
> On 09/09/09 16:34, Anthony Liguori wrote:
>   
>> We haven't even been successful in getting the Xen folks to present 
>> their work on lkml before shipping it to their users.  Why would we 
>> expect more from VMware if we're willing to merge the Xen stuff?
>>   
>>     
>
> The Xen code may be out of tree, but it has always been readily
> available from a well-known place.  I don't think its comparable.
>   

Once an ABI is set in stone, there's very little that can be done on 
lkml to review the ABI in any serious way.

VMware has repeatedly done this in the past.  Ship a product with their 
own drivers, then submit something to lkml saying that the ABI cannot be 
changed because it's present in a shipping product.

I'll admit, Xen hasn't been as bad as VMware in this regard, but it's 
certainly not perfect either.

Regards,

Anthony Liguori

>     J
>   

