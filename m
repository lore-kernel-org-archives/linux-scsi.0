From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [SCSI] sd: Lower printk level for drive cache information
Date: Mon, 28 Nov 2011 23:44:42 -0500
Message-ID: <20111129044442.GA19616@infradead.org>
References: <20111128163053.GA24618@zod.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111128163053.GA24618@zod.bos.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 28, 2011 at 11:31:55AM -0500, Josh Boyer wrote:
> Numerous devices don't present cache data, particularly USB sticks.  The
> devices operate correctly despite this, so lower the printk severity to
> KERN_NOTICE.

Do they?  The last reports on the list were for devices that didn't
present it but actually needed cache flushes despite not having the
cache mode page.
