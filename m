From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [0/27]
Date: Thu, 17 Feb 2005 19:38:49 +0000
Message-ID: <20050217193849.GA7824@infradead.org>
References: <4214D5B1.1060701@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:60056 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262345AbVBQTiv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 14:38:51 -0500
Content-Disposition: inline
In-Reply-To: <4214D5B1.1060701@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Feb 17, 2005 at 12:34:41PM -0500, Luben Tuikov wrote:
> Hi,
> 
> Adaptec would like to announce its SAS/SATA Linux device driver
> for inclusion into the Linux kernel.
> 
> The driver supports Adaptec's AIC-94XX chip based, eight port SAS
> and SATA 64-bit PCI-X, 133MHz ASIC controller.
> 
> The driver source is presented as a broken up BK patch over
> the latest scsi-misc-2.6 kernel.  The code is compatible
> with both 2.4 and 2.6 kernels.
> 
> The authors of this code will be monitoring the mailing list
> for your comments.

The driver is the same mess as aic7xxx and aic79xx and everything we
told you about it applies there aswell.  Also as with the Fusion SAS
submission it won't go in until there's a SAS and phy transport class
to share common code between drivers.
