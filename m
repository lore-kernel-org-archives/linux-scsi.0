From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] SCSI target for IBM Power5 LPAR
Date: Wed, 07 Sep 2005 13:56:38 -0500
Message-ID: <431F37E6.3080706@cs.wisc.edu>
References: <20050906212801.GB14057@cs.umn.edu> <20050907104932.GA14200@lst.de> <20050907124504.GA13614@cs.umn.edu> <431F35D2.7040209@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751268AbVIGS4s@vger.kernel.org>
In-Reply-To: <431F35D2.7040209@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: boutcher@cs.umn.edu, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, Santiago Leon <santil@us.ibm.com>, Linda Xie <lxiep@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Dave C Boutcher wrote:
> 
>> On Wed, Sep 07, 2005 at 12:49:32PM +0200, Christoph Hellwig wrote:
>>
>>> On Tue, Sep 06, 2005 at 04:28:01PM -0500, Dave C Boutcher wrote:
>>>
>>>> This device driver provides the SCSI target side of the "virtual
>>>> SCSI" on IBM Power5 systems.  The initiator side has been in mainline
>>>> for a while now (drivers/scsi/ibmvscsi/ibmvscsi.c.)  Targets already
>>>> exist for AIX and OS/400.
>>>
>>>
>>> Please try to integrate that with the generic scsi target framework at
>>> http://developer.berlios.de/projects/stgt/.
>>
>>
>>
>> There hasn't been a lot of forward progress on stgt in over a year, and
>> there were some issues (lack of scatterlist support, synchronous and
>> serial command execution) that were an issue when last I looked.
>>
>> Vlad, can you comment on the state of stgt and whether you see it
>> being ready for mainline any time soon?
> 
> 
> Sorry, I can see on stgt page only mail lists archive and not from start 
> (from Aug 22). Mike, can I see stgt code and some design description, 
> please? You can send it directly on my e-mail address, if necessary.


goto the svn page for the code
http://developer.berlios.de/svn/?group_id=4492

As for design desc, I do not have anything. It is the evolving source :) 
We are slowly merging leasons we learned from open-iscsi, your SCST 
code, the available software and HW targets, and the SCSI ULD's 
scatterlist code which needs redoing so it is a bit of a mess.
