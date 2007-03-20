From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] libata: reimplement suspend/resume support using sdev->manage_start_stop
Date: Tue, 20 Mar 2007 15:29:19 +0000
Message-ID: <20070320152919.GA28403@infradead.org>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <20070320152533.GH6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070320152533.GH6152@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 21, 2007 at 12:25:33AM +0900, Tejun Heo wrote:
> Reimplement suspend/resume support using sdev->manage_start_stop.
> 
> * Device suspend/resume is now SCSI layer's responsibility and the
>   code is simplified a lot.

Finally.  I've been telling people to do it this way forever.

Can you please also kill the braindead suspend and resume scsi_host_template
methods now?

