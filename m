From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/3] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Tue, 22 Mar 2016 00:54:05 -0700
Message-ID: <20160322075405.GA20141@infradead.org>
References: <1448358147-23663-1-git-send-email-linux@rasmusvillemoes.dk>
 <878u1sd9xb.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878u1sd9xb.fsf@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Julian Calaby <julian.calaby@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 08, 2016 at 08:52:32PM +0100, Rasmus Villemoes wrote:
> On Tue, Nov 24 2015, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> 
> > This reduces the impact of choosing CONFIG_SCSI_CONSTANTS by about 8KB.
> >
> 
> ping? does anyone feel like picking these up?

Please resend them against the current tree.  I'm pretty sure I acked
your appraoch, and if I didn't give you an actualy review I'll happily
do that after a repost.
