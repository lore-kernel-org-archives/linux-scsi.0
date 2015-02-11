From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Subject: Re: CONFIG_SCSI_MQ_DEFAULT cause slow direct write speed to usb
 stick
Date: Wed, 11 Feb 2015 14:02:37 +0100
Message-ID: <20150211140237.29101167@bigpc>
References: <20150210195036.3dce0e9e@bigpc>
	<54DA81CA.2030303@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54DA81CA.2030303@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, martin.petersen@oracle.com, elliott@hp.com
List-Id: linux-scsi@vger.kernel.org

Hi,

my problem was, that write speed to the device is got really slow from
7 Mb/s to 250 Kb/s, so 16.76 Mb/sec is probably the speed limitation of
the uSD Card or is close to that. Do you activated blk-mq for scsi in
kernel config or in boot parameters?

Regards,
Andrej

On Tue, 10 Feb 2015 17:10:18 -0500
Douglas Gilbert <dgilbert@interlog.com> wrote:

> Here is an example:
> 
> # ddpt if=/dev/sg1 bs=512 of=x.bin
> 1953792+0 records in
> 1953792+0 records out
> 1281 retries after EAGAIN error(s) during IO
> time to transfer data: 59.678788 secs at 16.76 MB/sec
> 
> That is not a bad transfer time but other utilities
> or drivers might dwell longer on those (nuisance) EAGAINs.
