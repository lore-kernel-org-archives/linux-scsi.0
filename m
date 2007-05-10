From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/7] libata: check for AN support
Date: Wed, 9 May 2007 22:09:52 -0700
Message-ID: <20070509220952.5fa34822.akpm@linux-foundation.org>
References: <20070510072247.063476979@intel.com>
	<20070509163809.7b0b3fde.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070509163809.7b0b3fde.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, "Randy.Dunlap" <rdunlap@xenotime.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, 9 May 2007 16:38:09 -0700 Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:

>  /**
> + *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
> + *                       with sector count set to indicate
> + *                       Asynchronous Notification feature

I think kenreldoc requires that all this be on a single line?

> + *	@dev: Device to which command will be sent
> + *
> + *	Issue SET FEATURES - SATA FEATURES command to device @dev
> + *	on port @ap.
> + *
> + *	LOCKING:
> + *	PCI/etc. bus probe sem.
> + *
> + *	RETURNS:
> + *	0 on success, AC_ERR_* mask otherwise.
> + */

ooh, locking and return value documentation.  Often missed, and nice.
