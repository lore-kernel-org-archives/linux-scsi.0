From: Florenz Kley <florenz.kley@sap.com>
Subject: Re: Linux Driver test tools?
Date: Sun, 02 Jun 2002 17:42:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <15080000.1023032535@[10.18.201.22]>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F2633D1@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <F6A3AFC9BCD92E48B79C14E4AAAEA20F2633D1@nonamea.ptu.promise.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Haofeng Kou <haofengk@ptu.promise.com>
Cc: linux-scsi@vger.kernel.org

hi Haofeng,

--On Friday, May 31, 2002 06:42:15 PM -0700 Haofeng Kou 
<haofengk@ptu.promise.com> wrote:

> I finish one linux driver and want to do the whole features testing for
> this driver, any body know certain tools for this testing ?

there's a test tool written by Robin Miller at 
http://www.bit-net.com/~rmiller/dt.html
it has a good documentation, and lot's of possibilities to do torment 
different sorts of devices, among them disks. You can let it write stuff to 
a disk, defining a pattern to be written, and then read in the data again 
and verify it.

my approach testing drivers for disks is:

   - where to write/read?
      + directly to/from the device
      + to/from a filesystem on the device
      + to/from a LV that has it's PVs on the device

   - IO region
      + PAE in the different options
      + try to force it to make I/O from/to certain regions, like filling 
up the RAM, then writing a file to the device

for a server, the PAE option would most probably be 64GB, so I start 
normally with this enabled.

-- 
regards,
Florenz

