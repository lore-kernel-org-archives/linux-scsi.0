From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi_dh_alua: Do not modify the interval value for
 retries
Date: Tue, 2 May 2017 08:17:58 +0200
Message-ID: <1844f5eb-11c1-e041-4b2d-e12520b4e576@suse.de>
References: <20170428130626.32162-1-mwilck@suse.com>
 <20170428130626.32162-2-mwilck@suse.com>
 <1493404499.2767.13.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751123AbdEBGSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 May 2017 02:18:00 -0400
In-Reply-To: <1493404499.2767.13.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "mwilck@suse.com" <mwilck@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/28/2017 08:35 PM, Bart Van Assche wrote:
> On Fri, 2017-04-28 at 15:06 +0200, Martin Wilck wrote:
>> @@ -886,7 +883,7 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
>>  		force = true;
>>  	}
>>  	if (pg->rtpg_sdev == NULL) {
>> -		pg->interval = 0;
>> +		pg->interval = 2;
>>  		pg->flags |= ALUA_PG_RUN_RTPG;
>>  		kref_get(&pg->kref);
>>  		pg->rtpg_sdev = sdev;
> 
> Hello Hannes and Martin,
> 
> Why is .interval initialized in alua_rtpg_queue() instead of in
> alua_alloc_pg()? I think initializing it in alua_alloc_pg() would
> make more clear that .interval is constant.
> 
Yes, valid point.
Will be doing so.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
