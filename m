From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] qla2x: fix printk format warnings
Date: Wed, 18 Feb 2009 13:30:33 -0800
Message-ID: <20090218133033.df24dfd3.akpm@linux-foundation.org>
References: <20090218131120.d1beb9f7.randy.dunlap@oracle.com>
	<20090218212249.GL16841@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbZBRVbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 16:31:17 -0500
In-Reply-To: <20090218212249.GL16841@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-driver@qlogic.com, linux-ia64@vger.kernel.org

On Wed, 18 Feb 2009 14:22:50 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Feb 18, 2009 at 01:11:20PM -0800, Randy Dunlap wrote:
> > drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 5)
> 
> I thought we were going to fix all these by making u64 an unsigned long
> long on all 64-bit architectures?  I know benh is working on it for
> powerpc, and I sent a patch to do it for ia64.  Don't think Tony's
> merged it yet ...

Yes, we should do this.  But momentum seems to have faded again.

