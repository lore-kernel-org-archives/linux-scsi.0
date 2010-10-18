From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFCv3 20/21] tcm: Add Kbuild and Kconfig for drivers/target
	and Documentation/target/
Date: Mon, 18 Oct 2010 16:03:42 -0700
Message-ID: <1287443022.14039.198.camel@haakon2.linux-iscsi.org>
References: <1287441559-20129-1-git-send-email-nab@linux-iscsi.org>
	 <20101018154859.66b71121.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.52]:36211 "HELO
	nm14-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755405Ab0JRXIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 19:08:31 -0400
In-Reply-To: <20101018154859.66b71121.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2010-10-18 at 15:48 -0700, Randy Dunlap wrote:
> On Mon, 18 Oct 2010 15:39:19 -0700 Nicholas A. Bellinger wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Add TCM Kbuild and Kconfig files and update drivers/ to pick up drivers/target.
> > Add Docmentation/target/ for tcm_mod_builder.py script for generating new
> > TCM v4 fabric modules functional ConfigFS skeletons.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  Documentation/target/tcm_mod_builder.py  | 1094 ++++++++++++++++++++++++++++++
> >  Documentation/target/tcm_mod_builder.txt |  145 ++++
> >  drivers/Kconfig                          |    2 +
> >  drivers/Makefile                         |    1 +
> >  drivers/target/Kbuild                    |   27 +
> >  drivers/target/Kconfig                   |   34 +
> >  6 files changed, 1303 insertions(+), 0 deletions(-)
> >  create mode 100755 Documentation/target/tcm_mod_builder.py
> >  create mode 100644 Documentation/target/tcm_mod_builder.txt
> >  create mode 100644 drivers/target/Kbuild
> >  create mode 100644 drivers/target/Kconfig
> 
> 
> > diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> > new file mode 100644
> > index 0000000..5c37653
> > --- /dev/null
> > +++ b/drivers/target/Kconfig
> > @@ -0,0 +1,34 @@
> > +config TARGET_CORE
> > +        tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
> > +	select CONFIGFS_FS
> 
> Indentation: use tabs, not spaces.
> 

Whoops, fixed.  Thanks for spotting this..

> > +        default m
> 
> Don't enable random drivers/modules.
> Let the user or defconfig do that.

Understood, changing to 'default n'.

Thanks!

--nab

