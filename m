From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: x86_64 + 2.6.1-rc3 panics on aic79xx
Date: 08 Jan 2004 12:26:07 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1073582767.2741.14.camel@mulgrave>
References: <200401081627.i08GRgZ0000027670@mudpuddle.cs.wustl.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200401081627.i08GRgZ0000027670@mudpuddle.cs.wustl.edu>
To: Berkley Shands <berkley@cs.wustl.edu>
Cc: gibbs@scsiguy.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2004-01-08 at 11:27, Berkley Shands wrote:
> 	A pure stock 2.6.1-rc3 kernel also bug halts with sg corruption
> on the first scsi retry. It seems that the iommu has serious issues
> with all three variants of  current kernel patches.

Andi Kleen has produced a patch for the sg list problems.  Could you see
if you can reproduce the issues when Andi produces a patch kit for
x86_64 and -rc3, so we're not trying to debug non-scsi issues?

Thanks,

James
