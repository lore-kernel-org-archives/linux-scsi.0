From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: ConfigFS + Target Mode Engine API discussion
Date: Wed, 10 Sep 2008 23:38:47 -0700
Message-ID: <20080911063846.GB16583@mail.oracle.com>
References: <1221087547.27831.165.camel@haakon2.linux-iscsi.org> <20080910233107.GC23864@mail.oracle.com> <1221097366.27831.216.camel@haakon2.linux-iscsi.org> <20080911021331.GA12902@mail.oracle.com> <1221107358.27831.289.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:54352 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYIKGku (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2008 02:40:50 -0400
Content-Disposition: inline
In-Reply-To: <1221107358.27831.289.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>

On Wed, Sep 10, 2008 at 09:29:18PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2008-09-10 at 19:13 -0700, Joel Becker wrote:
> > On Wed, Sep 10, 2008 at 06:42:46PM -0700, Nicholas A. Bellinger wrote:
> > > So I am thinking about the following question:  What would be the
> > > preferred method for calling ct_group_ops->make_group() in order to
> > > create the $CONFIGFS/target/$FABRIC struct config_item directly from
> > > target_fabric_configfs_register() call?  From there, the config group
> > > hanging off $CONFIGFS/target/$FABRIC will be fabric dependent and
> > > providing their own groups, items, depends, from the passed *fabric_cit.
> > > How do I "simulate" a mkdir(2) configfs -> make_group() call coming from
> > > the fabric module itself..?   This would be assuming that both mkdir(2)
> > 
> > 	That's precisely what you don't do with configfs.  It's a
> > defined "not to be done" thing.  So there's no preferred way, there's no
> > way at all.
> > 	What you want do to is drive this from mkdir().  The
> > make_group() will look up the sub-module it needs and return the
> > appropriate item.
> > 
> 
> Whew, good thing I asked about this case first..  :-)

	Can you give me a more complete description of what you're
trying to do?  that way I can maybe help with some suggestions.

Joel

-- 

"Win95 file and print sharing are for relatively friendly nets."
	- Paul Leach, Microsoft

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
