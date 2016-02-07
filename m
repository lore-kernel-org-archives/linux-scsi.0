From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Sun, 07 Feb 2016 08:04:00 -0800
Message-ID: <1454861040.2329.4.camel@HansenPartnership.com>
References: <1454783624.2809.6.camel@HansenPartnership.com>
	 <20160207092241.GA15331@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160207092241.GA15331@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2016-02-07 at 10:22 +0100, Christoph Hellwig wrote:
> Keith said it should be on by default, and I promised him to change
> it once we run into problems, which I guess this counts as.
> 
> But just curious:  what distro are you using?  Upstream systemd
> explicitly rejected using scsi_id for NVMe here:
> 
> 	https://github.com/systemd/systemd/issues/1453
> 
> and all my test systems don't do this either.

This was SUSE (in my case, openSUSE Leap).  I just checked the source
package; they patch the by-id rules back in for NVME:

# PATCH-FIX-SUSE 1101-rules-persistent-device-names-for-NVMe-devices.patch (bsc#944132)
Patch1101:      1101-rules-persistent-device-names-for-NVMe-devices.patch

The bugzilla is giving access denied for bug id 944132, so it's likely
some proprietary vendor problem.  The patch has no preamble, so it's
hard to tell what they were thinking.

James
