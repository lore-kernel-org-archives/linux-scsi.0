From: Tejun Heo <htejun@gmail.com>
Subject: Re: unexpected scsi timeout
Date: Tue, 24 Jul 2007 17:20:02 +0900
Message-ID: <46A5B632.8040201@gmail.com>
References: <46A0A462.2090407@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46A0A462.2090407@sw.ru>
Sender: linux-ide-owner@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devel@openvz.org, Albert Lee <albertcc@tw.ibm.com>
List-Id: linux-scsi@vger.kernel.org

[cc'ing Albert]

Vasily Averin wrote:
> Tejun, Jeff
> 
> I've noticed that some scsi commands for DVD-drive attached to pata_via
> successfully finishes without any delays but reports about TIMEOUT condition. It
> happens because of ATA_ERR bit is set in status register. As result for each
> command  Error Handler thread awakened, requests sense buffer and go to sleep again.

Need more info.  Please post boot dmesg and the result of 'lspci -nn'
and 'hdparm -I /dev/srX' and when such errors occur.

Thanks.

-- 
tejun
