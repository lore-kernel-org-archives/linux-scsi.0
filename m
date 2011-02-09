From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: make scsi_devinfo infrastructure optional
Date: Wed, 09 Feb 2011 12:00:08 -0600
Message-ID: <1297274408.3016.29.camel@mulgrave.site>
References: <201102091515.16202.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201102091515.16202.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-02-09 at 15:15 +0100, Bartlomiej Zolnierkiewicz wrote:
> Add SCSI_QUIRKS config option (default y and dependent on EMBEDDED
> config option) to allow disabling of scsi_devinfo infrastructure.
> 
> The output code size savings are ~14k for CONFIG_SCSI_QUIRKS=n
> (as measured on x86-32):

I don't understand the point of this patch ... without the quirks SCSI
will do the wrong thing on a whole bunch of stuff.  The savings look to
be tiny ... since the SCSI module is habitually a lot larger than your
figures suggest.

James
