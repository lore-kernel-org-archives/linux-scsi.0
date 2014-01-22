From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [LSF/MM TOPIC] really large storage sectors - going beyond 4096
 bytes
Date: Wed, 22 Jan 2014 05:20:53 +0000
Message-ID: <20140122052052.GM10565@ZenIV.linux.org.uk>
References: <20131220093022.GV11295@suse.de>
 <52DF353D.6050300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <52DF353D.6050300@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
> One topic that has been lurking forever at the edges is the current
> 4k limitation for file system block sizes. Some devices in
> production today and others coming soon have larger sectors and it
> would be interesting to see if it is time to poke at this topic
> again.
> 
> LSF/MM seems to be pretty much the only event of the year that most
> of the key people will be present, so should be a great topic for a
> joint session.

Oh yes, I want in on this.  We handle 4k/16k/64k pages "seamlessly," and
we would want to do the same for larger sectors.  In theory, our code
should handle it with the appropriate defines updated.

Joel

-- 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
