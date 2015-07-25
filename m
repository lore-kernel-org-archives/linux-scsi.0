From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: add support for START_STOP_UNIT SCSI opcode
Date: Fri, 24 Jul 2015 23:32:19 -0700
Message-ID: <20150725063219.GD26437@infradead.org>
References: <1437516477-30554-1-git-send-email-sbaugh@catern.com>
 <20150723093618.GA5382@infradead.org>
 <877fpqfr19.fsf@ponos.purestorage.com>
 <94D0CD8314A33A4D9D801C0FE68B40295AA06D79@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295AA06D79@G9W0745.americas.hpqcorp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Spencer Baugh <sbaugh@catern.com>, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Brian Bunker <brian@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 24, 2015 at 03:06:12AM +0000, Elliott, Robert (Server Storage) wrote:
> Note that the officially published versions of the ISO and ANSI 
> standards don't carry that revision number r36; they just have
> the standard name and year.  SBC-3 revision 36 became 
> "ANSI INCITS 514-2014 Information technology - SCSI Block 
> Commands - 3 (SBC-3)".
> 
> T10 isn't really obligated to keep making particular working 
> drafts available, although the ones that have been assigned
> version descriptors (in SPC-n) are more likely to stick 
> around.  For SBC-3, only revisions 35 and 36 earned those.

Unfortunately the final T10 standards are only available for a high
monetary cost, so they aren't useful for Free Software development.

We work arounds this by referencing specific drafts that are available.
If T10 would regress even more by not providing them we'd have to find
other work arounds.
