From: Willem Riede <wriede@riede.org>
Subject: Re: [PATCH] allow NULL dev argument to scsi_add_host
Date: Sat, 11 Jan 2003 17:32:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111223200.GZ1378@linnie.riede.org>
References: <20030111203317.A25836@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030111203317.A25836@lst.de>; from hch@lst.de on Sat, Jan 11, 2003 at 14:33:17 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On 2003.01.11 14:33 Christoph Hellwig wrote:
> We need scsi_add_host sometimes without having a struct device (i.e.
> eisa/vlb drivers, ieee1394 storage), so handle that case gracefully.
> 
Hmmm, I created a token device for ide-scsi (idescsi_primary) because
that null case wasn't handled. Should I delete it again?

Thanks, Willem Riede.
