From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/2] cciss: remove calls to pci_disable_device
Date: Wed, 13 Dec 2006 13:07:04 +0100
Message-ID: <20061213120703.GN4576@kernel.dk>
References: <20061212195458.GB2471@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964876AbWLMMFp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061212195458.GB2471@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: mike.miller@hp.com, mikem@beardog.cca.cpqcorp.net
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 12 2006, Mike Miller (OS Dev) wrote:
> PATCH 2/2
> 
> This patch removes calls to pci_disable_device except in
> fail_all_cmds. The pci_disable_device function does something nasty to
> Smart Array controllers that pci_enable_device does not undo. So if
> the driver is unloaded it cannot be reloaded.  Also, customers can
> disable any pci device via the ROM Based Setup Utility (RBSU). If the
> customer has disabled the controller we should not try to blindly
> enable the card from the driver.  Please consider this for inclusion.

Applied 1+2 for inclusion.

-- 
Jens Axboe
