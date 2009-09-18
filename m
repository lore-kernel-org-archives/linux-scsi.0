From: Chris Webb <chris@arachsys.com>
Subject: Re: MD/RAID time out writing superblock
Date: Fri, 18 Sep 2009 18:07:42 +0100
Message-ID: <20090918170742.GJ2141@arachsys.com>
References: <20090917115728.GA13854@arachsys.com>
 <4AB2596D.10809@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757100AbZIRRIZ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AB2596D.10809@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Chris Webb wrote:
>
> > Would such very slow (but ultimately successful) flushes be
> > consistent with the theory of power supply issues affecting the
> > drives? It feels like the 30s timeouts on flush could be just a more
> > severe version of the 15s very slow flushes.
> 
> Probably not.  Power problems usually don't resolve themselves with
> longer timeout.  If the drive genuinely takes longer than 30s to
> flush, it would be very interesting tho.  That's something people have
> been worrying about but hasn't materialized yet.  The timeout is
> controlled by SD_TIMEOUT in drivers/scsi/sd.h.  You might want to bump
> it up to, say, 60s and see whether anything changes.

I'll add that to the list of things to check out on the test machine with a
more disposable installation on it! The 15s flushes we're seeing on
superblock barrier writes do already feel dangerously close to the 30s
hardcoded timeout to me: it's only a factor of two.

Cheers,

Chris.
