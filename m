From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Tue, 13 Nov 2018 17:25:42 +0100
Message-ID: <ec46a643-9166-58d8-87ce-5a10f9709010@suse.de>
References: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com>
 <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
 <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de>
 <1542125473.3042.6.camel@linux.vnet.ibm.com>
 <c58db296-87ec-5aaf-f6ce-1115d5d2a2c1@suse.de>
 <CAJr6mf299-x5RmX3Lm=pVwWoP_374sMi8sw3x=h8TgG0t0d0SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJr6mf299-x5RmX3Lm=pVwWoP_374sMi8sw3x=h8TgG0t0d0SA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Cc: jejb@linux.vnet.ibm.com, john.garry@huawei.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, martin.petersen@oracle.com, Souptick Joarder <jrdr.linux@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Brajeswar Ghosh <brajeswar.linux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 13/11/2018 17:22, Sabyasachi Gupta wrote:
> On Tue, Nov 13, 2018 at 9:46 PM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>>
>> On 13/11/2018 17:11, James Bottomley wrote:
>>> This is incorrect advice: there's no need to cast it to other *pointer*
>>> types, but if you cast it to a non-pointer type (which this is doing)
>>> the compiler will complain if there is no explicit cast.
> shall I leave the typecast as it is?

Yes, sorry for not looking at it deeply enough.

-- 
Johannes Thumshirn                                        SUSE Labs
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
