From: Jeff Garzik <jeff@garzik.org>
Subject: Re: What's left in libata-dev.git?
Date: Thu, 25 Oct 2007 06:11:31 -0400
Message-ID: <47206BD3.4070004@garzik.org>
References: <472067FD.3060400@garzik.org> <47206A5A.7080306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47206A5A.7080306@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, Jason Gaston <jason.d.gaston@intel.com>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> 3) Tejun: libata: implement ata_wait_after_reset()
>>
>>     ^^^  Tejun, what case does this solve?  Still needed?
> 
> Not needed yet.  It will be necessary to support a weird device (CF 
> bridged over SATA) but it's a nice clean up regardless (instead of 
> quoting ATADVDR in every reset functions).  Any reason not to put it in?

<looks at it again>  I suppose not :)  I will put it in.

	Jeff


