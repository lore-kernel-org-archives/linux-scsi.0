From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Wed, 24 Aug 2005 16:05:03 -0400
Message-ID: <430CD2EF.8010108@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050822045502.GA7147@lists.us.dell.com> <430A05F2.10009@adaptec.com> <20050822215316.GB8083@us.ibm.com> <430BB779.2060209@adaptec.com> <20050824171241.GB16652@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17096 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932072AbVHXUFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 16:05:15 -0400
In-Reply-To: <20050824171241.GB16652@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Matt Domsch <Matt_Domsch@dell.com>, James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/24/05 13:12, Patrick Mansfield wrote:
> On Tue, Aug 23, 2005 at 07:55:37PM -0400, Luben Tuikov wrote:
> 
>>Where does udev get its label?
> 
> 
> You can call any script or program from udev and use the result. There are

And where does _it_ get it?

> recent changes for persistent naming, the /dev/by-id naming used in sles9
> is in current udev.
> 
> A tmp /dev node is available to called out programs, so any pass through
> or regular IO can be sent to the device before it has its real name.  So
> you should be able to get anything available on the scsi device that way.

*"SCSI DEVICE"*, not SAS of FC or iSCSI or whatever.
Now, where will that *scsi device* get _its_ label?

> udev now has an "IMPORT" rule, see usage of scsi_id, vol_id, etc. in
> current udev rules.
> 
> Followup posts should go to linux-hotplug-devel@lists.sourceforge.net

Hey Patrick, is there a point to this thread?
If you have an idea, please go ahead and share and/or implement it.
If you're unclear on something please ask it directly.

	Luben
