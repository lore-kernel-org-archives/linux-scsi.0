From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for asynchronous scans to libata
Date: Mon, 11 Dec 2006 22:02:40 -0700
Message-ID: <20061212050239.GG21070@parisc-linux.org>
References: <20061208211236.GC29763@parisc-linux.org> <457D84C9.6020907@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <457D84C9.6020907@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 11, 2006 at 11:18:17AM -0500, Jeff Garzik wrote:
> ACK.  I tried to apply the patch, but git-applymbox choked on every 
> single file modified.  Quite possibly, its due to a whitespace cleanup 
> in Alan territory.
> 
> If you would either (a) wait several hours for libata-dev.git#upstream 
> to mirror out, and resend, or (b) supply a git:// URL to pull from, I'll 
> merge.

Here's a merge against your upstream head.  It's perhaps more of a
conceptual merge as it adds entries to drivers that have been added
since I wrote the patch.  I also added a couple of missing slave_destroy
methods to the newly-added drivers.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
