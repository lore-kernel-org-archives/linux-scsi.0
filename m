From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/6] bfa: remove os wrapper functions and macros
Date: Wed, 20 Oct 2010 17:16:24 -0500
Message-ID: <4CBF6A38.7060502@cs.wisc.edu>
References: <1287447149-28678-1-git-send-email-huangj@brocade.com> <4CBF09DF.8000308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54469 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab0JTWJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2010 18:09:56 -0400
In-Reply-To: <4CBF09DF.8000308@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: Jing Huang <huangj@brocade.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/20/2010 10:25 AM, Rob Evers wrote:
> Is scsi_for_each_sg() use pretty standard for mass storage drivers these
> days?

Yes, the driver should be using it.

>
> Is the byte swapping required if the more traditional sg implementation
> is used?
>
>>
>> #ifndef __BIGENDIAN
>> -#define bfa_os_hton3b(_x) bfa_swap_3b(_x)
>> +#define bfa_os_hton3b(_x) bfa_swap_3b(_x)
>
> Should bfa_os_hton3b and related functionality be relocated
> appropriately and implemented in common form to the other common byte
> swapping code?
>

Yes. I think intel was working on that for fcoe. Someone should dig up 
the patches and finish pushing.
