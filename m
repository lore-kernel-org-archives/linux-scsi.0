From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [Regression 4.13-rc1] Resume does not work on Lenovo X60t
Date: Tue, 29 Aug 2017 11:40:53 +0200
Message-ID: <f415a9d7-25d4-77a6-b199-49b30ba989c0@molgen.mpg.de>
References: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
 <20170805093014.GA6511@infradead.org>
 <d30803d1861c9c105a35845759f58f8d@molgen.mpg.de>
 <9123f447-c06b-6a67-b380-90338eb2dde8@molgen.mpg.de>
 <20170821184115.GA16735@infradead.org>
 <3b5be305179828fd0e768c8ba9455851@molgen.mpg.de>
 <20170823114845.GB24217@infradead.org>
 <7e7e3ccf-f928-7fa5-1ea2-abbb94521cd7@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:58889 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751186AbdH2Jk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 05:40:56 -0400
In-Reply-To: <7e7e3ccf-f928-7fa5-1ea2-abbb94521cd7@molgen.mpg.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Dear Christoph,


On 08/23/17 14:15, Paul Menzel wrote:

> On 08/23/17 13:48, Christoph Hellwig wrote:
>> Are you running with blk-mq enabled?  Also this never
>> occurred with 4.12, right?  Were you also running with or
>> without blk-mq for scsi there?
> 
> To my knowledge, I am using the defaults from Debian 9. I’ll check in 
> one week, as I am away from the system.

It looks like I was using blk-mq, as it was the default up to commit 
cbe7dfa26eee (Revert "scsi: default to scsi-mq"). So with Linux 4.13-rc7 
and disabling blk-mq for SCSI, the system is functional again after resume.


Kind regards,

Paul
