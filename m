From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Tue, 22 Oct 2002 13:14:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021022131440.A7266@lst.de>
References: <20021021213441.A2864@lst.de> <20021022073040.GA10377@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021022073040.GA10377@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Oct 22, 2002 at 12:30:40AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Oct 22, 2002 at 12:30:40AM -0700, Mike Anderson wrote:
> It looks to me like we could also investigate removing sd_disks and
> sd_dsk_arr by using the per driver storage of the device model. In the 2
> sd_disks access cases we have the scsi_device and should be able to
> locate the device object. I believe the sd_dsk_arr could also be covered
> in a similar method.

Yes, that's on my TODO list for this week.
> 
