From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove unused includes and misleading comments from scsi_lib.c
Date: Wed, 20 Nov 2002 18:50:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021120185048.A4886@lst.de>
References: <20021117235449.B9824@lst.de> <20021120084709.A18453@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021120084709.A18453@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Nov 20, 2002 at 08:47:09AM -0800
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2002 at 08:47:09AM -0800, Patrick Mansfield wrote:
> I had to add back the smp_lock.h include to compile with CONFIG_PREEMPT,
> as kernel_locked was not defined and is used by in_atomic().

Bah.  Any chance you could fix the header declaring in_atomic() to pull
in smp_lock.h by itself instead?
