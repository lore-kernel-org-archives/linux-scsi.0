From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/6] bfa: remove os wrapper functions and macros
Date: Wed, 20 Oct 2010 18:50:58 -0500
Message-ID: <4CBF8062.9010609@cs.wisc.edu>
References: <1287447149-28678-1-git-send-email-huangj@brocade.com> <4CBF09DF.8000308@redhat.com> <4CBF6A38.7060502@cs.wisc.edu> <4CBF7569.90708@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55517 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab0JTXoZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2010 19:44:25 -0400
In-Reply-To: <4CBF7569.90708@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Rob Evers <revers@redhat.com>, Jing Huang <huangj@brocade.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/20/2010 06:04 PM, Joe Eykholt wrote:
>>>> #ifndef __BIGENDIAN
>>>> -#define bfa_os_hton3b(_x) bfa_swap_3b(_x)
>>>> +#define bfa_os_hton3b(_x) bfa_swap_3b(_x)
>>>
>>> Should bfa_os_hton3b and related functionality be relocated
>>> appropriately and implemented in common form to the other common byte
>>> swapping code?
>>>
>>
>> Yes. I think intel was working on that for fcoe. Someone should dig up the patches and finish pushing.
>
> It's in<scsi/fc_frame.h>  as hton24() / ntoh24().  It's written in
> an endian-independent way.   I don't know of patches to move them to
> a better place.

iscsi and some other code has it too. Chris Leech was working on it in 
this patchset "24-bit types: typedef and functions for accessing 3-byte 
arrays as integers". I think this was the latest:

http://www.mail-archive.com/jfs-discussion@lists.sourceforge.net/msg01330.html
