From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH for disabling write cache on SATA drives
Date: Mon, 28 Jun 2004 20:12:26 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <20040629001225.GA23878@havoc.gtf.org>
References: <1F6D1D1660975A4887628A011443A1BC07734BF9@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1F6D1D1660975A4887628A011443A1BC07734BF9@uswaumsx13medge.med.ge.com>
To: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 25, 2004 at 06:21:24PM -0500, Edwards, Scott (MED, Kelly IT Resouces) wrote:
> 
> I don't know if this is useful for anyone or if anyone even cares, but just
> in case someone does, this is the patch I made to disable the write cache on
> the Serial ATA drives.  It doesn't make the write cache controllable from
> the user level, it just ALWAYS disables it.  (I tried to make one that could
> be sent via an ioctl, but there were far too many things that I didn't
> understand and it didn't work.)  Since I have never done this before I don't
> know if there is some protocol that I missed, if so I'm sorry.  If there are
> glaring stupid mistakes (very likely) please let me know.

In principle your patch is fine, but I would really like to find a
better way of allowing the user to do this.

My immediate guess would be to use the standard SCSI method of disabling
write cache, and have that initiate wbcache disable on the SATA side.

Long term, this would be augmented by an "ATA passthru" opcode or ioctl.

	Jeff



