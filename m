From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH] scsi: ipr: fix build on 32-bit architectures
Date: Fri, 8 Jun 2018 15:39:23 -0400
Message-ID: <53f391e7-24b6-3c14-1e68-975078ae683b@codeaurora.org>
References: <20180608144617.2900894-1-arnd@arndb.de>
 <04758f3a-0f03-4fe9-6eb8-10ebb2430a98@codeaurora.org>
 <CAK8P3a2=uMFOcw=gZGuwsH+V=1DMXGgxf_hZHw3tMJD1nDdG2Q@mail.gmail.com>
 <830c2468-293c-385c-0b91-c96bedae4d4a@codeaurora.org>
 <07a50fe0-0378-769a-f4eb-d39ac543dc95@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <07a50fe0-0378-769a-f4eb-d39ac543dc95@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-scsi@vger.kernel.org

On 6/8/2018 3:20 PM, Brian King wrote:
>> I don't think there is a consensus about using these includes in the community.
>> I bumped into this issue before and came up with an include you pointed.
>> I didn't get too much enthusiasm from the maintainer.
>>
>> Why are we pushing the responsibility into the drivers? I'd think that architecture
>> should take care of this. Is there a portability issue that I'm missing from some
>> architecture I never heart of? (I work on Little-Endian machines most of the time)
> The attributes of the adapter hardware can have an impact here. The ipr hardware, for
> example, depends on the upper 4 bytes to be written first, then the lower 4 bytes
> to be written second, and its the act of writing the lower 4 bytes that triggers
> the adapter hardware to read the value and take action on it.

Thanks, I never thought about this.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
