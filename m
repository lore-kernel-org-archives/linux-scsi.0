From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH scsi-misc-2.6] SCSI: kill sht->suspend/resume
Date: Wed, 21 Mar 2007 14:19:39 +0000
Message-ID: <20070321141939.GA20117@infradead.org>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <20070320152533.GH6152@htj.dyndns.org> <20070320152919.GA28403@infradead.org> <20070321070516.GJ6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070321070516.GJ6152@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 21, 2007 at 04:05:16PM +0900, Tejun Heo wrote:
> With libata converted to use sdev->manage_start_stop for suspend and
> resume, sht->suspend/resume() has no user left and low level
> suspend/ressume should be taken care of by low level driver's
> suspend/resume callbacks (e.g. PCI or PCMCIA driver callbacks).  This
> patch removes sht->suspend/resume() callbacks.
> 
> This change is suggested by Christoph Hellwig.

Very nice, as the rest of the series.  Thanks a lot Tejun.

