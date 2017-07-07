From: Laurence Oberman <loberman@redhat.com>
Subject: Re: device support in hpsa, was: Re: OOPS from cciss_ioctl in
 4.12+git
Date: Fri, 7 Jul 2017 14:20:13 -0400
Message-ID: <1e3a19fa-1dab-b360-7dbb-bc6c007f6ddd@redhat.com>
References: <alpine.LRH.2.20.1707051555130.20086@math.ut.ee>
 <20170705225134.GA31786@infradead.org>
 <alpine.LRH.2.20.1707061236010.6514@math.ut.ee>
 <20170707150042.GA15445@infradead.org>
 <799cf0d6-658d-4124-1ba0-3962671e3f1e@kernel.dk>
 <1bc9895b-bfcb-9ff5-c046-277b0d67a94e@redhat.com>
 <20170707180857.GA19790@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:33215 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdGGSUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2017 14:20:18 -0400
Received: by mail-qt0-f181.google.com with SMTP id r30so33712785qtc.0
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jul 2017 11:20:18 -0700 (PDT)
In-Reply-To: <20170707180857.GA19790@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>



On 07/07/2017 02:08 PM, Christoph Hellwig wrote:
> On Fri, Jul 07, 2017 at 11:42:38AM -0400, Laurence Oberman wrote:
>> What happens when  hpsa_allow_any=1 with the Smart Array 64xx
>> It should probe.
> 
> But only if it has a HP vendor ID as far as I can tell.  We'd
> still need to add the compaq ids so that these controllers get
> probed.  But maybe it's time to add them and flip the hpsa_allow_any
> default (maybe conditionally on a config option?) and mark cciss
> deprecated.
> 
Agreed, I vote yes.
