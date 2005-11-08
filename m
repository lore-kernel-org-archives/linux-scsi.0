From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/10] remove scsi_request usage from sg and st
Date: Tue, 08 Nov 2005 04:10:31 -0600
Message-ID: <43707997.7020404@cs.wisc.edu>
References: <1131444389.23111.56.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:13727 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932391AbVKHKKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:10:42 -0500
In-Reply-To: <1131444389.23111.56.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org

Mike Christie wrote:
> The following patches, made against scsi-misc, remove the scsi_request
> usage from st and sg, do some tiny cleanup on sg, and make sg and st
> always perform scatterlist IO.
> 
> I have tested against libata and scsi_debug for disks. There are slight
> changes, so someone with a tape device should test the patches, but Kai
> since Kai did all the debugging last round I have not made many changes.
> We will probably hit many problems with LLDs using low max_hw_sectors,
> because they have not been converted to export their real values on the
> host template so I think these patches should sit in scsi-misc for a
> good deal of time.
> 

I for got to cc the st and sg maintainers. In case you guys do not 
follow linux-scsi closely and do not want all those patches sent to you 
I put them here
http://www.cs.wisc.edu/~michaelc/block/use-sg/v8/
I can email them again too if you want.
