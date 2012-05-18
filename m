From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 2/3] alua: retry alua rtpg extended header for illegal
 request response
Date: Fri, 18 May 2012 08:34:15 -0400
Message-ID: <4FB641C7.5040709@redhat.com>
References: <1337177705-17114-1-git-send-email-revers@redhat.com> <1337177705-17114-2-git-send-email-revers@redhat.com> <77471C95FAFD844C8CA02DD4F4C5FE2B06775B@SACEXCMBX02-PRD.hq.netapp.com> <4FB5AD44.2030705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965342Ab2ERMeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2012 08:34:16 -0400
In-Reply-To: <4FB5AD44.2030705@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/17/2012 10:00 PM, Rob Evers wrote:
> On 05/17/2012 05:02 PM, Moger, Babu wrote:
>
>>> +         * handles this.
>>> +         */
>>> +        if (sense_hdr.sense_key == ILLEGAL_REQUEST&&
>>> +            sense_hdr.asc == 0x24&&  sense_hdr.ascq == 0) {
>>> +            rtpg_ext_hdr_req = 0;
>>> +            goto retry;
>> We should probably have an exit criteria here.  What if target 
>> misbehaves
>> (with ILLEGAL_REQUEST) even with rtpg_ext_hdr_req = 0.
>
> Do you have a more detailed suggestion on the
> exit criteria?
>

Yes I got your point.  I'll repost.

