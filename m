From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] update MESH scsi driver
Date: Sun, 23 Mar 2003 08:12:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030323081223.A6568@infradead.org>
References: <15997.13267.498276.509580@nanango.paulus.ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15997.13267.498276.509580@nanango.paulus.ozlabs.org>; from paulus@samba.org on Sun, Mar 23, 2003 at 03:10:59PM +1100
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>
Cc: linux-scsi@vger.kernel.org, torvalds@transmeta.com

On Sun, Mar 23, 2003 at 03:10:59PM +1100, Paul Mackerras wrote:
> This patch updates the `mesh' scsi driver used on older powermacs to
> correspond with recent changes in the scsi subsystem (things like
> using cmd->device->id instead of cmd->target).

Looks good, please also make all functions static while you're at it.

(dito for mac53c94)
