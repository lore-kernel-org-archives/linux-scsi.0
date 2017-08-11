From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCHv2 2/4] scsi: Export blacklist flags to sysfs
Date: Fri, 11 Aug 2017 08:46:07 +0200
Message-ID: <b2756417-6ba7-aeb3-29a6-27e8988ea1b1@suse.com>
References: <1502275444-27676-1-git-send-email-hare@suse.de>
 <1502275444-27676-3-git-send-email-hare@suse.de> <yq1valv0w96.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:56808 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdHKGqm (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 11 Aug 2017 02:46:42 -0400
In-Reply-To: <yq1valv0w96.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Doug Gilbert <dgilbert@interlog.com>

On 08/11/2017 02:43 AM, Martin K. Petersen wrote:
> 
> Hannes,
> 
>> Each scsi device is scanned according to the found blacklist flags,
>> but this information is never presented to sysfs.  This makes it quite
>> hard to figure out if blacklisting worked as expected.  With this
>> patch we're exporting an additional attribute 'blacklist' containing
>> the blacklist flags for this device.
> 
> There have been changes to the blacklist values over the years so I'm
> not so keen on exporting them as a numbers.
> 
Ah, good to know.
I was thinking of exporting them as text; 'tis better for a quick check
anyway.
Would that be acceptable?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
