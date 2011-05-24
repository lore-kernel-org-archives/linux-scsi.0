From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2] MAINTAINERS: Add drivers/target/ entry
Date: Mon, 23 May 2011 23:11:09 -0700
Message-ID: <1306217469.29724.150.camel@haakon2.linux-iscsi.org>
References: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
	 <1306193789.8687.61.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306193789.8687.61.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-05-23 at 16:36 -0700, Joe Perches wrote:
> On Mon, 2011-05-23 at 14:10 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > +TARGET SUBSYSTEM
> > +M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
> > +L:	linux-scsi@vger.kernel.org
> > +L:	http://groups.google.com/group/linux-iscsi-target-dev
> > +W:	http://www.linux-iscsi.org
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
> > +S:	Supported
> > +F:	drivers/target/
> > +F:	include/target/
> > +F:	Documentation/target/
> 
> Shouldn't the file layout be more like
> 
> drivers/lio/target?
> 

Hi Joe,

Not sure what you mean here..  Currently drivers/target/ contains the
fabric independent target core, and /drivers/target/$FABRIC/ contains
individual fabric module drivers.

I originally decided to use drivers/target/ to avoid any confusion wrt
to the 'LIO' term, which to some folks is interchangable wrt to the
'iscsi-target' fabric module.

--nab
