From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 2.6] cciss typo fix
Date: Fri, 07 Jan 2005 18:32:02 -0500
Message-ID: <1105140722.4151.28.camel@mulgrave>
References: <D4CFB69C345C394284E4B78B876C1CF107DC0185@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261731AbVAGXnN@vger.kernel.org>
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF107DC0185@cceexc23.americas.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Cc: Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-01-07 at 17:24 -0600, Miller, Mike (OS Dev) wrote:
> Hmmm, SuSE complained that __be32 was not defined in the kernel. Any other thoughts, anyone?

Erm, well it might not be defined in the SuSE kernel ... that's based on
2.6.5, I believe.  These symbols are definitely defined in the mainline
kernel.

James
