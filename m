From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
Date: Thu, 3 Jul 2014 09:28:38 -0700
Message-ID: <20140703162838.GA14118@infradead.org>
References: <20140628174605.352098823@linuxfoundation.org>
 <20140628174609.930049472@linuxfoundation.org>
 <1404339330.1862.69.camel@ul30vt.home>
 <53B48B37.4000608@cs.wisc.edu>
 <1404341555.16066.19.camel@dabdike>
 <20140703060548.GB17456@infradead.org>
 <1404395645.1949.2.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404395645.1949.2.camel@jarvis.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Alex Williamson <alex.williamson@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 03, 2014 at 06:54:05AM -0700, James Bottomley wrote:
> Well it did:
> 
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/scsi?h=linux-3.15.y&id=04423ddea30a7fb7232636eda8aed55ea5b972fe
> 
> The stable process is a bit broken from my point of view since it
> doesn't copy linux-scsi on SCSI commits ... but this time even I didn't
> get a cc, so really no-one who knew there was a problem had a chance to
> comment.
> 
> The choice is either request revert from stable or add fix.

Unfortunately the fix hasn't even made it to mainline yet, despite lots
of people tripping over it.  If you're too busy I'm happy to send it to
Linus, it's been sitting in my tree for over a week now.

So if we can get it in ASAP we can also send it to stable, otherwise
a revert is the only option.
