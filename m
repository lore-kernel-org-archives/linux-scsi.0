From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: reduce CONFIG_SCSI_CONSTANTS impact by 4k
Date: Sat, 3 Oct 2015 10:14:37 -0700
Message-ID: <20151003171437.GA20847@infradead.org>
References: <87h9mbg6h1.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87h9mbg6h1.fsf@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Rasmus,

I like this idea.  But maybe it's also time to just move the constants
to a plain text file and auto-generate C headers from them?  That way
the format in which they can be edited is decoupled from the
representation in the kernel image.
