From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/6] hpsa legacy support
Date: Tue, 15 Aug 2017 08:22:10 +0200
Message-ID: <7c86397e-863c-5042-b817-b8c1a0d7fc46@suse.de>
References: <1502709555-15837-1-git-send-email-hare@suse.de>
 <yq14lt9wlco.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58925 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751666AbdHOGWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 02:22:12 -0400
In-Reply-To: <yq14lt9wlco.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org

On 08/15/2017 05:39 AM, Martin K. Petersen wrote:
> 
> Hannes,
> 
>> here's now the second attempt to add support for legacy boards, ie for
>> boards previously supported by cciss only.  With this patchset the
>> hpsa driver should work with all Smart Array boards if the
>> 'hpsa_allow_any' module option is set, rendering the cciss driver
>> obsolete.  Consequently I've added a patch to remove the cciss driver
>> and make 'hpsa' an alias to 'cciss'.
> 
> How does the module alias solve the problem that hpsa_allow_any=1 needs
> to be added for users currently running cciss?
> 
> I also fail to see what the point is of having an opt-in parameter when
> there is no alternative after cciss has been removed. It's a
> don't-be-broken switch.
> 
Hmm ... considering this (and the fact that we now have the
->legacy_board switch) we can indeed remove that option.
Will be redoing the patchset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
