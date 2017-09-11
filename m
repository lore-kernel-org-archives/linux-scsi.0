From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: 4.13+git: undefined references to bsg_setup_queue and
 bsg_job_done
Date: Mon, 11 Sep 2017 14:04:19 +0200
Message-ID: <20170911120419.jmtid2244iqwenui@linux-x5ow.site>
References: <alpine.LRH.2.21.1709111454020.23935@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1709111454020.23935@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2017 at 02:58:59PM +0300, Meelis Roos wrote:
> Just went and changed kernel conf to HPSA instead of old CCISS but got a 
> compilation failure:
> 
> drivers/scsi/scsi_transport_sas.o: In function `sas_bsg_initialize':
> scsi_transport_sas.c:(.text+0x12fd): undefined reference to `bsg_setup_queue'
> scsi_transport_sas.c:(.text+0x13b2): undefined reference to `bsg_setup_queue'
> drivers/scsi/scsi_transport_sas.o: In function `sas_smp_dispatch':
> scsi_transport_sas.c:(.text+0x188e): undefined reference to `bsg_job_done'
> Makefile:1000: recipe for target 'vmlinux' failed
> make: *** [vmlinux] Error 1

There's a fix from Arnd [1] for this and it is in Martin's queue.

[1] 580b71e9f64e0e6e9063466fce4564c56156695d

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
