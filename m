From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: linux-next: scsi tree build warnings
Date: Thu, 10 Sep 2009 17:08:17 +0000
Message-ID: <1252602497.11956.95.camel@mulgrave.site>
References: <20090907130024.d67c032d.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090907130024.d67c032d.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Love <robert.w.love@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2009-09-07 at 13:00 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> usr/include/scsi/fc/fc_els.h:165: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/scsi/fc/fc_fs.h:32: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/scsi/fc/fc_gs.h:29: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/scsi/fc/fc_ns.h:71: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> Introduced by commit 171bb4f9f6a20d405a3cb5111ce92ad83aae2302 ("[SCSI]
> libfc: Export FC headers").

OK, I've dropped this patch ... Robert, can you resubmit it when you've
verified it all works.

James
