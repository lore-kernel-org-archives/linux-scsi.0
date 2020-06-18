Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57722C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 08:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 300C42089D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 08:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgFRImb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 04:42:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:40744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgFRImb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 04:42:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D6A3AAC6;
        Thu, 18 Jun 2020 08:42:29 +0000 (UTC)
Subject: Re: [PATCH 1/4] gdth: reindent and whitespace cleanup
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200616121821.99113-1-hare@suse.de>
 <20200616121821.99113-2-hare@suse.de>
 <20200617082145.mdsu56bclo3p3dg4@beryllium.lan>
 <2a7473b3-62af-f7d2-f73a-adcabe21701e@suse.de>
 <72827be0-a44a-0163-acb8-04ff3bde86ce@suse.de>
 <20200618081407.qsm4otp2w2bmcuil@beryllium.lan>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <73b070da-2d27-d731-a8b2-b6a668524330@suse.de>
Date:   Thu, 18 Jun 2020 10:42:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618081407.qsm4otp2w2bmcuil@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/18/20 10:14 AM, Daniel Wagner wrote:
> On Wed, Jun 17, 2020 at 10:48:10AM +0200, Hannes Reinecke wrote:
>> On 6/17/20 10:34 AM, Hannes Reinecke wrote:
>>> On 6/17/20 10:21 AM, Daniel Wagner wrote:
>>>> On Tue, Jun 16, 2020 at 02:18:18PM +0200, Hannes Reinecke wrote:
>>>>> Long overdue. No functional change.
>>>>
>>>> Did you test if compiler generates the same output? I don't think anyone
>>>> wants to review this patch :)
>>>>
>>> Hmm. No. Lemme check what happens...
>>>
>> Phew. Just checked, and the disassembly is indeed identical.
> 
> I am not really convienced it is a good idea to reformat the whole
> driver at this point. Sure, checkpatch.pl & friends will be more
> happy with new changes. Though, in 10 years there were only 44
> changes and I don't think there will be a lot more in the coming
> years. Just my thoughts.
> 
Says you.

6fa4468afcf73a3f53a70f0e76a63d0a03b641fc gdth: kill 'cmnd' argument from 
gdth_execute()
652d47aa4b4fcc9422d99727671af178323f231f gdth: merge gdth_proc.c into gdth.c
aee96950cc505670d4befe9fb2f1faa0dfe179fb gdth: split off gdth_init_pci()
89d259c342c690d4110b04f3f21aa853f2e69ab7 gdth: convert TRACE macros to 
dynamic debug
70526df12feaa74c6fd487561fd52ac93e89e025 gdth: drop statistics during 
I/O submission
0e0c7414780dbfd86f19967f35481e3e99456551 gdth: replace blank printk() 
statements with dev_xxx variants
db9e448aae664f4b702849d40fa7de563563f68e gdth: stop abusing ->request 
pointer for completion
ac60bebd3a1d13a523e019440798f206e9cd83ce gdth: kill __gdth_execute()
4dded2800578c60e1c2b4dd6ee08b14bc9ef1181 gdth: do not use struct 
scsi_cmnd as argument for bus reset
6c599cfd05580969e13bdada8c54c0a643aa56f5 gdth: reindent and whitespace 
cleanup

As mentioned, the gdth driver is the only one using the scsi_host_dev 
feature, which I'll be improving/updating with my reserved tags for SCSI
patchset.
And to avoid my eyes falling out everytime I need to look at the driver
I would very much prefer to have the reindent done.

Especially as it can be easily verified.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
