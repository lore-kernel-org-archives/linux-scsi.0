From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 4.13+git: undefined references to bsg_setup_queue and
 bsg_job_done
Date: Mon, 11 Sep 2017 05:02:44 -0700
Message-ID: <20170911120244.GA26923@infradead.org>
References: <alpine.LRH.2.21.1709111454020.23935@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1709111454020.23935@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2017 at 02:58:59PM +0300, Meelis Roos wrote:
> Just went and changed kernel conf to HPSA instead of old CCISS but got a 
> compilation failure:

Martin has already applied a fix for this from Arnd, but it doesn't
seem to have made it to Linus yet due to the usual detour
via James' tree.

The fix is here:

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=4.14/scsi-queue&id=580b71e9f64e0e6e9063466fce4564c56156695d
