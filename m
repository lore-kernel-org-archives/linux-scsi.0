From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCHv2] hpsa: expose enclosures
Date: Tue, 7 Mar 2017 16:24:45 +0100
Message-ID: <af59c314-358c-0dba-722f-c582eabf1092@suse.com>
References: <1487847303-82580-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D194F331B4F@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:51114 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755349AbdCGPqf (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Tue, 7 Mar 2017 10:46:35 -0500
In-Reply-To: <4993A297653ECB4581FA5C3C31323D194F331B4F@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/07/2017 04:05 PM, Don Brace wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Thursday, February 23, 2017 4:55 AM
>> To: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
>> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
>> Hannes Reinecke <hare@suse.de>; Don Brace
>> <don.brace@microsemi.com>; Hannes Reinecke <hare@suse.com>
>> Subject: [PATCHv2] hpsa: expose enclosures
>>
>> EXTERNAL EMAIL
>>
>>
>> Some servers have a built-in enclosure which will show up on the
>> same bus as the internal physical devices. This patch fixes the
>> driver to expose them.
>>
>> Cc: Don Brace <don.brace@microsemi.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
> 
> Masking various SES targets is a conscious choice, not a design oversight.
> So, I have to decline this patch.,
> 
Would you be okay with a module parameter for this?
It really feels stupid to present the user with an enclosure device
during boot (as hpsa presents all physical LUNs during booting), but not
exporting it to the user.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
