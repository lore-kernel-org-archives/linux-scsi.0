From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 09:05:12 -0400
Message-ID: <42932688.80203@adaptec.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050524062128.GT9855@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/24/05 02:21, Jens Axboe wrote:
> suspend/resume is a lot more complicated than just flushing a cache, the
> below will probably get you safe asleep but you will never get devices
> alive again after power-up on suspend-to-ram.
> 
> I also greatly prefer issuing a standby command to the drive after the
> flush, so that we don't risk using the emergency parks of the drive. If
> a drive happens to lie about wrt the flush command, it gets an extra
> chance to flush the cache as it now knows that power will be gone very
> soon. So I think the ->suspend/->resume hooks should belong to the LLD,
> not the ULD as the ULD has no idea how to suspend all devices types.

Very, very true and very, very correct!

	Luben

