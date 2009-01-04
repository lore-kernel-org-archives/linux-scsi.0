From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/4] fastboot: make scsi probes asynchronous
Date: Sun, 4 Jan 2009 11:05:15 -0700
Message-ID: <20090104180515.GD2002@parisc-linux.org>
References: <20090104092430.7ffd2c41@infradead.org> <20090104092940.11943797@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090104092940.11943797@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 04, 2009 at 09:29:40AM -0800, Arjan van de Ven wrote:
> >From 2087b546abddced50fa73ea9a71b5a040ae1026e Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 4 Jan 2009 05:32:28 -0800
> Subject: [PATCH] fastboot: make scsi probes asynchronous
> 
> This patch makes part of the scsi probe (which is mostly device spin up and the
> partition scan) asynchronous. Only the part that runs after getting the device
> number allocated is asynchronous, ensuring that device numbering remains stable.

Is this really a big win?  Were you using the async scsi scan code
already?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
