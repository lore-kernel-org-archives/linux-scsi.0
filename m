From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain
	backward compatibility
Date: 11 Apr 2003 15:14:32 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1050092073.2078.219.camel@mulgrave>
References: <UTC200304111945.h3BJjU409008.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <UTC200304111945.h3BJjU409008.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2003-04-11 at 14:45, Andries.Brouwer@cwi.nl wrote:
> I think compatibility is very important.
> Linux does not arbitrarily break old systems. The aim must be
> to have all combinations of (old/new) kernel with (old/new) glibc
> to work well in all situations where old kernel + old glibc worked.

Well, if you're going to do this, at least make it possible to tie all
the sd devices to a single major (i.e. the numeric compatibility layer
simply maps to the new single major scheme internally).  It would also
be nice for numeric compatibility to be a compile time option too...

It's also possible that SCSI may not be the only consumer of such a
compatibility layer (IDE also has multiple majors), so it may be
worthwhile putting it somewhere more globally useful (like
fs/block_dev.c)

James
