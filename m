From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 21 Dec 2002 12:45:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021221174554.GA9703@redhat.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com> <176730000.1040430221@aslan.btc.adaptec.com> <20021221002940.GM25000@holomorphy.com> <190380000.1040432350@aslan.btc.adaptec.com> <20021221013500.GN25000@holomorphy.com> <223910000.1040435985@aslan.btc.adaptec.com> <20021221085510.A25881@infradead.org> <4093022704.1040484612@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4093022704.1040484612@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@infradead.org>, William Lee Irwin III <wli@holomorphy.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Dec 21, 2002 at 08:30:12AM -0700, Justin T. Gibbs wrote:
> revision.  I just do it as a single CSET with the comments dispersed
> into the individual files that the comments apply to.

Which is perfectly acceptable IMHO.  There is no reason that a cset need 
document all the details when the file logs already do.  A cset need only 
indicate what basic work is being done and maybe a list of files in the 
cset.  Doing a bk changes -v gets the file comments as well for those 
people that want them.

I actually like the individual file comments part of the cset setup.  It's 
what my preferred use is when I'm making my own patches.  Make the cset 
have a summary of the major changes, then let each file have it's own 
detail change information.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
