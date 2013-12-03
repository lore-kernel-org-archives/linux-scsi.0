From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: qla2xxx: automatically rescan removed luns.
Date: Tue, 03 Dec 2013 17:35:07 +0000
Message-ID: <529E164B.4080009@mpstor.com>
References: <52936EB4.4090508@mpstor.com> <1385399823.3839.116.camel@localhost.localdomain> <5294C721.4070802@mpstor.com> <5294CBC7.3000604@interlog.com> <52974533.3030508@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.blacknight.com ([78.153.203.205]:55340 "EHLO
	relay2.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3LCRfJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2013 12:35:09 -0500
In-Reply-To: <52974533.3030508@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, dgilbert@interlog.com
Cc: emilne@redhat.com, linux-scsi@vger.kernel.org

On 28/11/13 13:29, Hannes Reinecke wrote:
> On 11/26/2013 05:26 PM, Douglas Gilbert wrote:
>> On 13-11-26 11:06 AM, Benjamin ESTRABAUD wrote:
> [ .. ]
>>> "rescan-scsi-bus.sh" did detect new LUN, but apparently not
>>> removed ones.
>>> However I need to test it on a system with a compatible bash shell
>>> as I wasn't
>>> able to run the script without errors.
>>
>> Did you try the rescan-scsi-bus.sh from sg3_utils v 1.37 or
>> earlier? The reason I ask is that a fair amount of work
>> was done on the rescan-scsi-bus.sh found in version 1.37
>> including syncing with Kurt Garloff's version 1.57 plus
>> patches from Hannes Reinecke and Sean Stewart.
>>
> Plus you need to call it with '-r', otherwise it won't remove any
> stale LUNs. I'm sure it's documented somewhere ...
>
Hi Doug and Hannes,

I did indeed try but I was using an older version and without specifying 
"-r" so it didn't remove anything.

I looked at the latest version's "remove" code (at around line 445 from 
rescan-scsi-bus.sh) and it seems to delete disks using the scsi_device 
sysfs "delete" function (which is the function I'm using right now).

I was unable to tell how the script detects whether a drive is gone or 
has been replaced with another backend storage at the same LUN, which in 
fact turns out to be the thing I'm more interested in (since I can now 
delete stale luns).

Thanks in advance for your help!

> Cheers,
>
> Hannes
>

Regards,
Ben.
