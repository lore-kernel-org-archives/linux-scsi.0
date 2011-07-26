From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 02/12] bnx2fc: Introduce interface structure for
 each vlan interface
Date: Tue, 26 Jul 2011 09:13:01 -0700
Message-ID: <4E2EE78D.9080006@broadcom.com>
References: <1309242664-27252-1-git-send-email-bprakash@broadcom.com>
 <1309242664-27252-3-git-send-email-bprakash@broadcom.com>
 <1311673302.17353.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4790 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab1GZQNV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 12:13:21 -0400
In-Reply-To: <1311673302.17353.21.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 7/26/2011 2:41 AM, James Bottomley wrote:
> On Mon, 2011-06-27 at 23:30 -0700, Bhanu Prakash Gollapudi wrote:
>> Currently, bnx2fc has a hba structure that can work with only a single vlan
>> interface.  When there is a change in vlan id, it does not have the capability
>> to switch to different vlan interface. To solve this problem, a new structure
>> called 'interface' has been introduced, and each hba can now have multiple
>> interfaces, one per vlan id.
>>
>> Most of the patch is a moving the interface specific fields from hba to the
>> interface structure, and appropriately modifying the dereferences. A list of
>> interfaces (if_list) is maintained along with adapter list. During a create
>> call, the interface structure is allocated and added to if_list and deleted&
>> freed on a destroy call.  Link events are propogated to all interfaces
>> belonging to the hba.
>
> Best I can tell, the upstream prerequisites are satisfied, but I still
> can't apply this because of a conflicting upstream patch:
>
> commit 415199f2bd977fa4065d4e836b4b7543f7993bc3
> Author: Michael Chan<mchan@broadcom.com>
> Date:   Wed Jul 20 14:55:24 2011 +0000
>
>      cnic: Add VLAN ID as a parameter during netevent upcall
>
> Which actually introduces an explicit failure return for vlans.  Could
> you respin from 2 on to sort this out?

Sure, will try and resolve the conflicts and re-submit the patches.

Thanks,
Bhanu.

>
> Thanks,
>
> James
>
>
>


