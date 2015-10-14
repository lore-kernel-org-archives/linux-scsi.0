From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] SCSI: Fix hard lockup in scsi_remove_target()
Date: Wed, 14 Oct 2015 09:12:38 -0700
Message-ID: <20151014161238.GA31708@infradead.org>
References: <cover.1444829611.git.jthumshirn@suse.de>
 <1444833036.2220.38.camel@HansenPartnership.com>
 <1444833547.19542.21.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444833547.19542.21.camel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 14, 2015 at 04:39:07PM +0200, Johannes Thumshirn wrote:
> removal. This is what my initial proposal did as well. Christoph wanted
> me to decouple the whole process from the host_lock though and this is
> what this patches do as well now.

I think we've talked past each other, I didn't intend to say that and
my replies to you don't seem to imply that either.

I'll draft a patch for what I meant.
