From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [Regression 4.13-rc1] Resume does not work on Lenovo X60t
Date: Wed, 23 Aug 2017 14:15:09 +0200
Message-ID: <7e7e3ccf-f928-7fa5-1ea2-abbb94521cd7@molgen.mpg.de>
References: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
 <20170805093014.GA6511@infradead.org>
 <d30803d1861c9c105a35845759f58f8d@molgen.mpg.de>
 <9123f447-c06b-6a67-b380-90338eb2dde8@molgen.mpg.de>
 <20170821184115.GA16735@infradead.org>
 <3b5be305179828fd0e768c8ba9455851@molgen.mpg.de>
 <20170823114845.GB24217@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50750 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753793AbdHWMPL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 08:15:11 -0400
In-Reply-To: <20170823114845.GB24217@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Dear Christoph,


On 08/23/17 13:48, Christoph Hellwig wrote:
> Are you running with blk-mq enabled?  Also this never
> occured with 4.12, right?  Were you also running with or
> without blk-mq for scsi there?

To my knowledge, I am using the defaults from Debian 9. I’ll check in 
one week, as I am away from the system.


Kind regards,

Paul
