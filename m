From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Wed, 24 Aug 2005 13:42:14 -0700
Message-ID: <20050824204214.GA21794@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050822045502.GA7147@lists.us.dell.com> <430A05F2.10009@adaptec.com> <20050822215316.GB8083@us.ibm.com> <430BB779.2060209@adaptec.com> <20050824171241.GB16652@us.ibm.com> <430CD2EF.8010108@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:252 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S932168AbVHXUmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 16:42:33 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7OKgTSh448818
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 16:42:30 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7OKgcdc368352
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 14:42:39 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7OKgTJn007285
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 14:42:29 -0600
Content-Disposition: inline
In-Reply-To: <430CD2EF.8010108@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: ltuikov@yahoo.com, linux-scsi@vger.kernel.org

On Wed, Aug 24, 2005 at 04:05:03PM -0400, Luben Tuikov wrote:
> On 08/24/05 13:12, Patrick Mansfield wrote:
> > On Tue, Aug 23, 2005 at 07:55:37PM -0400, Luben Tuikov wrote:
> > 
> >>Where does udev get its label?
> > 
> > 
> > You can call any script or program from udev and use the result. There are
> 
> And where does _it_ get it?

You can write a program to supply it :)

And then try to get it into your favourite distribution ...

> > recent changes for persistent naming, the /dev/by-id naming used in sles9
> > is in current udev.
> > 
> > A tmp /dev node is available to called out programs, so any pass through
> > or regular IO can be sent to the device before it has its real name.  So
> > you should be able to get anything available on the scsi device that way.
> 
> *"SCSI DEVICE"*, not SAS of FC or iSCSI or whatever.
> Now, where will that *scsi device* get _its_ label?
> 
> > udev now has an "IMPORT" rule, see usage of scsi_id, vol_id, etc. in
> > current udev rules.
> > 
> > Followup posts should go to linux-hotplug-devel@lists.sourceforge.net
> 
> Hey Patrick, is there a point to this thread?

Yes, at this juncture a simplified explanation about udev rules.

> If you have an idea, please go ahead and share and/or implement it.
> If you're unclear on something please ask it directly.

I thought you were asking for details about udev ... your question was
rather ambiguous.

-- Patrick Mansfield
