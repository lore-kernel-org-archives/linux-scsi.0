From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Tue, 13 Nov 2018 17:16:26 +0100
Message-ID: <c58db296-87ec-5aaf-f6ce-1115d5d2a2c1@suse.de>
References: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com>
 <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
 <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de>
 <1542125473.3042.6.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542125473.3042.6.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, John Garry <john.garry@huawei.com>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, martin.petersen@oracle.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 13/11/2018 17:11, James Bottomley wrote:
> This is incorrect advice: there's no need to cast it to other *pointer*
> types, but if you cast it to a non-pointer type (which this is doing)
> the compiler will complain if there is no explicit cast.

Right, sorry for that and thanks for spotting it James.

Byte,
	Johannes
-- 
Johannes Thumshirn                                        SUSE Labs
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
