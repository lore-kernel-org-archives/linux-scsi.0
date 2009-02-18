From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2x: fix printk format warnings
Date: Wed, 18 Feb 2009 14:22:50 -0700
Message-ID: <20090218212249.GL16841@parisc-linux.org>
References: <20090218131120.d1beb9f7.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090218131120.d1beb9f7.randy.dunlap@oracle.com>
Sender: linux-ia64-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>, jejb <James.Bottomley@HansenPartnership.com>, linux-driver@qlogic.com, linux-ia64@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 18, 2009 at 01:11:20PM -0800, Randy Dunlap wrote:
> drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 5)

I thought we were going to fix all these by making u64 an unsigned long
long on all 64-bit architectures?  I know benh is working on it for
powerpc, and I sent a patch to do it for ia64.  Don't think Tony's
merged it yet ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
