From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
Date: Thu, 1 Jan 2009 18:26:37 -0500
Message-ID: <20090101232637.GC31367@fieldses.org>
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com> <20081229121423.efde9d06.akpm@linux-foundation.org> <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <495C8B65.4010202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <495C8B65.4010202@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, open-osd development <osd-dev@open-osd.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, jeff@garzik.org, linux-kernel@vger.kernel.org, avishay@gmail.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 01, 2009 at 11:22:45AM +0200, Benny Halevy wrote:
> On Dec. 31, 2008, 17:57 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > I don't like it mainly because it's not truly a useful general framework
> > for others to build on.  However, as argued above, there might not
> > actually be such a useful framework, so as long as the only two
> > consumers (you and Lustre) want an interface like this, I'll put it in.
> 
> Not to mention pnfs over objects which is coming up around the corner.
> The pnfs-obj layout driver will use the osd initiator library as well
> for distributed data I/O access (while the metadata server, to be based
> on exofs accesses the OSD for metadata and security ops too)

What state is that project in right now?

--b.
