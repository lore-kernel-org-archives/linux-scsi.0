From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] SCSI target for IBM Power5 LPAR
Date: Wed, 07 Sep 2005 12:04:59 -0500
Message-ID: <431F1DBB.8020107@cs.wisc.edu>
References: <20050906212801.GB14057@cs.umn.edu> <20050907104932.GA14200@lst.de> <20050907124504.GA13614@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750882AbVIGRFj@vger.kernel.org>
In-Reply-To: <20050907124504.GA13614@cs.umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: Christoph Hellwig <hch@lst.de>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, Santiago Leon <santil@us.ibm.com>, Linda Xie <lxiep@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Dave C Boutcher wrote:
> On Wed, Sep 07, 2005 at 12:49:32PM +0200, Christoph Hellwig wrote:
> 
>>On Tue, Sep 06, 2005 at 04:28:01PM -0500, Dave C Boutcher wrote:
>>
>>>This device driver provides the SCSI target side of the "virtual
>>>SCSI" on IBM Power5 systems.  The initiator side has been in mainline
>>>for a while now (drivers/scsi/ibmvscsi/ibmvscsi.c.)  Targets already
>>>exist for AIX and OS/400.
>>
>>Please try to integrate that with the generic scsi target framework at
>>http://developer.berlios.de/projects/stgt/.
> 
> 
> There hasn't been a lot of forward progress on stgt in over a year, and
> there were some issues (lack of scatterlist support, synchronous and
> serial command execution) that were an issue when last I looked.
> 

stgt is not scst. It is new. And yes we will have proper support for 
sccatterlists. We need something similar to what sg and st need so I 
plan on using the block layer functions that are implemented for those 
upper layer drivers for stgt. If you want to help out and implement that 
then that would be good. We are also very early in our design so all 
comments are welcome.
