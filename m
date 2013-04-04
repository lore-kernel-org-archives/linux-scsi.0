From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] [PATCH] scsi-dh-emc: fix activate vs set_params race
Date: Thu, 4 Apr 2013 19:17:15 -0400 (EDT)
Message-ID: <D21B24A6-F860-4742-BAC8-3FF68EF5D29E@redhat.com>
References: <Pine.LNX.4.64.1304021954420.27554@file.rdu.redhat.com> <515E08AD.3060404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:37060 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765073Ab3DDXRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Apr 2013 19:17:20 -0400
In-Reply-To: <515E08AD.3060404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Rob Evers <revers@redhat.com>

I can test it. I have a clarion Cx3
Will get to it next week, traveling tomorrow
Laurence

Sent from my iPhone

On Apr 4, 2013, at 7:11 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:

> On 04/02/2013 07:09 PM, Mikulas Patocka wrote:
>> Hi
>> 
>> This fixes a possible race in scsi_dh_emc. It is untested because I don't 
>> have the hardware. It could happen when we reload a multipath device and 
>> path failure happens at the same time.
> 
> 
> I think this patch is ok. I do not have the hw to test it anymore.
> 
> If you wanted to test just to make sure it is safe you should bug Rob
> Evers. He can help you find a machine in the westford lab that has it
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
