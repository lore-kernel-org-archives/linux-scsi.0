From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Re: READ CAPACITY(16) failed, failure in mpt2sas_transport_port_add
Date: Sat, 28 Jan 2012 15:32:09 +1030
Message-ID: <20120128050209.GD31749@tuon>
References: <20120125015725.GA2938@tuon>
 <A6888A6805518E4EA4AF7072A28264A6048BC1A2FE@inbmail02.lsi.com>
 <20120125080728.GA1957@tuon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28577 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab2A1FKQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jan 2012 00:10:16 -0500
Content-Disposition: inline
In-Reply-To: <20120125080728.GA1957@tuon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, stable@vger.kernel.org

On Wed, Jan 25, 2012 at 06:37:28PM +1030, Kevin Shanahan wrote:
> On Wed, Jan 25, 2012 at 10:52:34AM +0530, Nandigama, Nagalakshmi wrote:
> > Request to apply the attached patch and test.
> >  scsi-misc-2[1].6.git-2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45.patch
> 
> Great, that fixes the issue!

Any chance this patch can go into 3.2.3?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45

Makes my Intel/LSI SAS controller usable, working great on top of
3.2.1 for several days now.

Thanks,
Kevin.
