From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC v2 PATCH 0/19] A kernel-level configfs enabled generic	target
 engine for Linux v2.6.32
Date: Mon, 21 Sep 2009 22:52:29 +0400
Message-ID: <4AB7CB6D.9000200@vlnb.net>
References: <1253311656.4498.143.camel@haakon2.linux-iscsi.org>	 <4AB76BBB.3040703@vlnb.net> <1253547536.26893.21.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:64854 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZIUSwM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2009 14:52:12 -0400
In-Reply-To: <1253547536.26893.21.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Daniel Walker <dwalker@fifo99.com>

Nicholas A. Bellinger, on 09/21/2009 07:38 PM wrote:
> On Mon, 2009-09-21 at 16:04 +0400, Vladislav Bolkhovitin wrote:
>> Nicholas A. Bellinger, on 09/19/2009 02:07 AM wrote:
>>> Greetings all,
>>>
>>> This is the second round of request for comments for TCM/ConfigFS v3.2 from lio-core-2.6.git.
>>> Thanks to the folks who made comments, and I again invite people to take a look and make
>>> recommendations on how the code can be futher improved to use the best available upstream
>>> interfaces.
>>>
>>> Also, the standalone patches for TCM v3.2 are now available from:
>>>
>>> http://kernel.org/pub/linux/kernel/people/nab/target_core_mod-patches/
>>>
>>> The first posting from 09112009 can be found here:
>>>
>>> http://marc.info/?l=linux-kernel&m=125272088024636
>>>
>>> The changelog since the posting on 09112009, which can be found here:
>>>
>>> *) Convert to struct mutex for struct sempahore initialized with init_MUTEX() (mentioned by Daniel Walker)
>>> *) Convert to struct completion for struct semaphore initialized with init_MUTEX_LOCKED() (mentioned by Daniel Walker)
>>> *) Convert to use Kbuild instead of Makefile for drivers/target/ (mentioned by Boaz Harrosh)
>>> *) Use include/asm-generic/div64.h for unsigned long long division on 32-bit architectures
>>> *) Use include/linux/math64.h for unsigned long long modulo on 32-bit architectures
>>>
>>> The lio-core-2.6.git tree can be found here:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary
>>>
>>> More Information about Target_Core_Mod/ConfigFS, and PR and ALUA:
>>>
>>> http://www.linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
>>> http://www.linux-iscsi.org/index.php/Persistent_Reservations
>>> http://www.linux-iscsi.org/index.php/ALUA
>>>
>>> The complete v3.x TCM CLI operations set can be found here:
>>>
>>> http://www.linux-iscsi.org/index.php/Lio-utils#v3.1_TCM_CLI_operations
>>>
>>> Instructions and examples for getting setup:
>>>
>>> http://www.linux-iscsi.org/builds/docs/LIO-3.0-Users_Reference_Manual.pdf
>>> http://www.linux-iscsi.org/index.php/Howto#Start_target_core_mod
>> Nicholas,
>>
>> In the previous iteration of this patchset I asked you some essential 
>> questions about what advantages TCM has over STGT which can't be 
>> implemented in STGT and can justify the move from it to TCM, as well as 
>> how did you test TCM to claim that TCM is generic and, hence, can work 
>> with hardware target adapters (http://lkml.org/lkml/2009/9/15/315). 
>> There was no reply answering those questions, instead you keep pushing 
>> your patches.
> 
> I am ignoring you because you ask questions that yourself have already
> answered.  (why having certain drivers in kernel vs. user target mode
> implementations make more sense than others).

Basically, none of those my arguments can be applicable to TCM in its 
current state and all TCM "advantages" like PRs can be well implemented 
in STGT, so I wonder, why do you bother people with requests for 
"*inclusion* of Target_Core_Mod/ConfigFS v3.2 from lio-core-2.6.git code 
*into mainline v2.6.32*" for such a raw code?

Vlad

