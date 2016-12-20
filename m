From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 09/11] lpfc: Correct oops on vport port resets
Date: Tue, 20 Dec 2016 20:56:34 +0100
Message-ID: <4d824fed-245c-20d3-04b3-52d592b98d9f@suse.de>
References: <58586831.FyDLkYbAFDWuYypA%james.smart@broadcom.com>
 <79712a55-ff54-0c08-9cc6-28f96a421101@suse.de>
 <1529c8e5-82ad-152d-c7e8-3e5a43871c2d@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764449AbcLTT4h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 14:56:37 -0500
In-Reply-To: <1529c8e5-82ad-152d-c7e8-3e5a43871c2d@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 05:51 PM, James Smart wrote:
>
>
> On 12/20/2016 5:47 AM, Hannes Reinecke wrote:
>>
>> Now that is what I call a dodgy interface.
>> Casting a 128-bit structure to a 64-bit structure, only to call a memset
>> on the 128-bit structure in lpfc_sli4_iocb2wqe() is positively evil.
>> Can't you clear up this mess by generally passing in a wqe128?
>>
>> Cheers,
>>
>> Hannes
>
> Completely agree. Wanted to get this in now to avoid the issue, and the
> better clean up done afterward as its a bit more involved.
>
If you promise to...

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
