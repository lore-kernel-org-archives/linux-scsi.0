From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 09:15:26 -0700
Message-ID: <5b2229ee-a225-b59f-ccdf-710767941920@kernel.dk>
References: <20170111134312.GH6286@linux-x5ow.site>
 <1484150893.2619.1.camel@sandisk.com> <20170111161238.GA18881@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37745 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758056AbdAKQP3 (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 11:15:29 -0500
Received: by mail-it0-f48.google.com with SMTP id r185so76702169ita.0
        for <Linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 08:15:28 -0800 (PST)
In-Reply-To: <20170111161238.GA18881@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "Linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "keith.busch@intel.com" <keith.busch@intel.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>

On 01/11/2017 09:12 AM, hch@infradead.org wrote:
> On Wed, Jan 11, 2017 at 04:08:31PM +0000, Bart Van Assche wrote:
>> A typical Ethernet network adapter delays the generation of an interrupt
>> after it has received a packet. A typical block device or HBA does not delay
>> the generation of an interrupt that reports an I/O completion.
> 
> NVMe allows for configurable interrupt coalescing, as do a few modern
> SCSI HBAs.

Unfortunately it's way too coarse on NVMe, with the timer being in 100
usec increments... I've had mixed success with the depth trigger.

-- 
Jens Axboe

