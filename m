From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ConfigFS + Target Mode Engine API discussion
Date: Wed, 10 Sep 2008 21:29:18 -0700
Message-ID: <1221107358.27831.289.camel@haakon2.linux-iscsi.org>
References: <1221087547.27831.165.camel@haakon2.linux-iscsi.org>
	 <20080910233107.GC23864@mail.oracle.com>
	 <1221097366.27831.216.camel@haakon2.linux-iscsi.org>
	 <20080911021331.GA12902@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:39162 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750712AbYIKE3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2008 00:29:25 -0400
In-Reply-To: <20080911021331.GA12902@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>

On Wed, 2008-09-10 at 19:13 -0700, Joel Becker wrote:
> On Wed, Sep 10, 2008 at 06:42:46PM -0700, Nicholas A. Bellinger wrote:
> > So I am thinking about the following question:  What would be the
> > preferred method for calling ct_group_ops->make_group() in order to
> > create the $CONFIGFS/target/$FABRIC struct config_item directly from
> > target_fabric_configfs_register() call?  From there, the config group
> > hanging off $CONFIGFS/target/$FABRIC will be fabric dependent and
> > providing their own groups, items, depends, from the passed *fabric_cit.
> > How do I "simulate" a mkdir(2) configfs -> make_group() call coming from
> > the fabric module itself..?   This would be assuming that both mkdir(2)
> 
> 	That's precisely what you don't do with configfs.  It's a
> defined "not to be done" thing.  So there's no preferred way, there's no
> way at all.
> 	What you want do to is drive this from mkdir().  The
> make_group() will look up the sub-module it needs and return the
> appropriate item.
> 

Whew, good thing I asked about this case first..  :-)

Thanks!

--nab

> Joel
> 
> 

