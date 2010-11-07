From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH] SCSI host lock push-down
Date: Sun, 07 Nov 2010 13:56:46 +0100
Message-ID: <8762w9thpt.fsf@basil.nowhere.org>
References: <20101105002409.GA21714@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101105002409.GA21714@havoc.gtf.org> (Jeff Garzik's message of
	"Thu, 4 Nov 2010 20:24:10 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> There were some previous attempts to push the SCSI host lock down
> into each driver.  In both cases, authors working independently of
> each other managed to both (a) skip some drivers that need updates, and,
> (b) get the locking wrong in some cases and/or rewrite the locking.

I took a quick look and there are no obvious problems in this 
version (except of lack of cc to previous contributors)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
