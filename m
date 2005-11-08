From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/10] remove scsi_request usage from sg and st
Date: Tue, 08 Nov 2005 10:54:58 -0600
Message-ID: <4370D862.6080602@cs.wisc.edu>
References: <1131444389.23111.56.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58016 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030255AbVKHQzC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 11:55:02 -0500
In-Reply-To: <1131444389.23111.56.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

Mike Christie wrote:
> We will probably hit many problems with LLDs using low max_hw_sectors,
> because they have not been converted to export their real values on the
> host template so I think these patches should sit in scsi-misc for a
> good deal of time.
> 

oh yeah just to clarify, this patch [PATCH 2/10] seperate max sectors 
and max hw sectors, makes it so the scsi host template's max_sectors is 
passed up as q->max_hw_sectors. I did not know the correct limit for any 
SCSI LLD's sht->max_sectors so I could not convert them if they were 
previously setting a conservtaive value for reasons like libata.
