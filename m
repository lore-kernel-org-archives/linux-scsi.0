From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: sg: Prevent potential double frees in sg driver
Date: Thu, 3 Aug 2017 12:51:05 -0700
Message-ID: <20170803195105.GB26674@kroah.com>
References: <20170803190248.51537-1-ndesaulniers@google.com>
 <20170803192354.GA1598@kroah.com>
 <CAKwvOdmkCtmceK8prnZJn6QQ9oReN2EUMSukWLS=NmgF_GagiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdmkCtmceK8prnZJn6QQ9oReN2EUMSukWLS=NmgF_GagiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: hare@suse.de, jthumshirn@suse.de, hch@lst.de, Mark Salyzyn <salyzyn@google.com>, Robb Glasser <rglasser@google.com>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 03, 2017 at 12:34:51PM -0700, Nick Desaulniers wrote:
> > Why no one on the to: line?
> 
> I usually cc everyone from get_maintainer.pl. Should I be using
> --to= then explicitly for named folks, and --cc= for lists?

That's usually a good idea, many email clients throw away stuff if there
is nothing on the "To:" line.

> > And do you want this in the stable kernel trees?
> 
> Looks like I can follow up on option #2 once this patch has
> been reviewed+merged by maintainers.  I'll note to use
> option #1 next time, unless you suggest I send a v2? I can
> do so if this patch has a v2+.

If you have to resend it, then add it, otherwise please remember when it
hits Linus's tree to send the git commit id to stable@vger and the
developers there can handle it.

thanks,

greg k-h
