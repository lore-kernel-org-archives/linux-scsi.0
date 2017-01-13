From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: RFC: 512e ZBC host-managed disks
Date: Fri, 13 Jan 2017 09:14:41 +0900
Message-ID: <1f93b23c-fc62-4e07-0550-3b6eefe2a7dc@wdc.com>
References: <38404478-7b9a-35ed-8148-81a05bd01ac8@wdc.com>
 <20170112082048.GA8276@lst.de>
 <x49eg08codc.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63054 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdAMAOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 19:14:48 -0500
In-Reply-To: <x49eg08codc.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>



On 1/13/17 00:02, Jeff Moyer wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
>> On Thu, Jan 12, 2017 at 05:13:52PM +0900, Damien Le Moal wrote:
>>> (3) Any other idea ?
>>
>> Do nothing and ignore the problem.  This whole idea so braindead that
>> the person coming up with the T10 language should be shot.  Either a device
>> has 511 logical sectors or 4k but not this crazy mix.
>>
>> And make sure no one ships such a piece of crap because we are hell
>> not going to support it.
> 
> Agreed.  This is insane.

Christoph, Jeff,

Thank you for the feedback.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
