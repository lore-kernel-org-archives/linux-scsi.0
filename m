From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 1/6] target/file: Re-enable optional fd_buffered_io=1
 operation
Date: Tue, 02 Oct 2012 15:02:17 -0400
Message-ID: <506B3A39.9010408@vlnb.net>
References: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org> <1348984696-30992-2-git-send-email-nab@linux-iscsi.org> <20121001084605.GA23497@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121001084605.GA23497@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig, on 10/01/2012 04:46 AM wrote:
> On Sun, Sep 30, 2012 at 05:58:11AM +0000, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger<nab@linux-iscsi.org>
>>
>> This patch re-adds the ability to optionally run in buffered FILEIO mode
>> (eg: w/o O_DSYNC) for device backends in order to once again use the
>> Linux buffered cache as a write-back storage mechanism.
>>
>> This difference with this patch is that fd_create_virtdevice() now
>> forces the explicit setting of emulate_write_cache=1 when buffered FILEIO
>> operation has been enabled.
>
> What this lacks is a clear reason why you would enable this inherently
> unsafe mode.  While there is some clear precedence to allow people doing
> stupid thing I'd least like a rationale for it, and it being documented
> as unsafe.

Nowadays nearly all serious applications are transactional, and know how to flush 
storage cache between transactions. That means that write back caching is 
absolutely safe for them. No data can't be lost in any circumstances.

Welcome to the 21 century, Christoph!

Vlad
