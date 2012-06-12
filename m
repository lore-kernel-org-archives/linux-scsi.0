From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Can we pass a file handle down to the block ioctls to implement
 per file filters on scsi SG_IO ?
Date: Tue, 12 Jun 2012 21:13:54 +0200
Message-ID: <4FD794F2.2080000@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com> <20120612175503.3462962f@pyramind.ukuu.org.uk> <4FD777A5.9050001@redhat.com> <20120612195200.2a1b6129@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120612195200.2a1b6129@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, jbottomley@parallels.com, Al Viro <viro@ZenIV.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

Il 12/06/2012 20:52, Alan Cox ha scritto:
> > Sure; however, doing so requires access to some member of "struct file"
> > from SG_IO.  Thus, ioctl would need to take a "struct file" rather than
> > just an fmode_t.
> > 
> > The switch to fmode_t was done in 2007 by Al Viro.  I would like to
> > understand the reasons for the switch; it seems to me that it was part
> > of the big kernel lock removal.  If it's acceptable to undo it, I would
> > very much would like to add generic BPF filtering to SG_IO
> 
> That would solve all sorts of problems in this area, so lets ping the man
> himself -  Al ?

(Even if he says no, we could probably use cgroups instead).

Paolo
