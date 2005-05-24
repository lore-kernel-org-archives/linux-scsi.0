From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 09:59:54 +0200
Message-ID: <20050524075953.GY9855@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4292CF5D.90809@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 24 2005, Jeff Garzik wrote:
> The SCSI layer needs to issue the START STOP UNIT command in response to 
> a suspend event, and libata-scsi will (per SAT spec) translate that into 
> the ATA standby command.  Merely following the relevant SCSI+SAT+ATA 
> standards gets us there.

BTW, you also need to set host/device modes on resume. Where do you
propose to do that currently, without the LLD hook?

-- 
Jens Axboe

