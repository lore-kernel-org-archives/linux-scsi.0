From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [scsi] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one()
Date: Thu, 13 Jun 2013 10:44:27 +0800
Message-ID: <20130613024427.GA11085@localhost>
References: <20130613013032.GA7558@localhost>
 <1371090883.1978.61.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1371090883.1978.61.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 12, 2013 at 07:34:43PM -0700, James Bottomley wrote:
> On Thu, 2013-06-13 at 09:30 +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit a256ba092ec57213f96059d41ac5473ff92f5e7c
> > Author: Nicholas Bellinger <nab@linux-iscsi.org>
> > Date:   Sat May 18 02:40:43 2013 -0700
> > 
> >     scsi: Split scsi_dispatch_cmd into __scsi_dispatch_cmd setup
> >     
> >     Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> You may be evaluating a bogus branch because no such commit has darkened
> the SCSI list, so it obviously can't be on upstream track.

Yeah, sorry I should probably not CC linux-scsi.

The bug is still in a private tree:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git  scsi-mq

Thanks,
Fengguang
