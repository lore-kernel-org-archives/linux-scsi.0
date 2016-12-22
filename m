From: Christoph Hellwig <hch@lst.de>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
        iscsi_tcp_segment_done+0x20d/0x2e0
Date: Thu, 22 Dec 2016 07:36:56 +0100
Message-ID: <20161222063656.GA31973@lst.de>
References: <20161214222411.GH4326@dastard> <20161214222953.GI4326@dastard> <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org> <20161221221638.GD4758@dastard> <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com> <20161222061827.GA31630@lst.de> <20161222063046.GH4758@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161222063046.GH4758@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 22, 2016 at 05:30:46PM +1100, Dave Chinner wrote:
> > For "normal" bios the for_each_segment loop iterates over bi_vcnt,
> > so it will be ignored anyway.  That being said both I and the lists
> > got CCed halfway through the thread and I haven't seen the original
> > report, so I'm not really sure what's going on here anyway.
> 
> http://www.gossamer-threads.com/lists/linux/kernel/2587485

This doesn't look like the discard changes, but if Chris wants to test
without them f9d03f96b988 reverts cleanly.
