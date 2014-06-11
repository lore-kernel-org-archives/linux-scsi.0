From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 11 Jun 2014 05:01:43 -0700
Message-ID: <20140611120143.GA26071@infradead.org>
References: <20140519140614.GA12183@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140519140614.GA12183@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

After this first pull for the 3.16 merge window it seems like this
worked out fairly well - we got a large number of patches in, and all
reviewed by a second pair of eyes.

How should we go on from this?  The drivers-for-3.16-2 branch, which had
the late lpfs and hpsa updates didn't make it into the pull request for
Linus, do you intend to skip them for this window?  If not do you still
want to have another branch for the other pending smaller updates?
