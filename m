From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Wed, 24 Aug 2005 10:12:41 -0700
Message-ID: <20050824171241.GB16652@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050822045502.GA7147@lists.us.dell.com> <430A05F2.10009@adaptec.com> <20050822215316.GB8083@us.ibm.com> <430BB779.2060209@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38123 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751223AbVHXRNN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 13:13:13 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7OHD1u5007315
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 13:13:01 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7OHD18a262482
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 13:13:01 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7OHD03U022788
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 13:13:01 -0400
Content-Disposition: inline
In-Reply-To: <430BB779.2060209@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Matt Domsch <Matt_Domsch@dell.com>, James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Tue, Aug 23, 2005 at 07:55:37PM -0400, Luben Tuikov wrote:
> 
> Where does udev get its label?

You can call any script or program from udev and use the result. There are
recent changes for persistent naming, the /dev/by-id naming used in sles9
is in current udev.

A tmp /dev node is available to called out programs, so any pass through
or regular IO can be sent to the device before it has its real name.  So
you should be able to get anything available on the scsi device that way.

udev now has an "IMPORT" rule, see usage of scsi_id, vol_id, etc. in
current udev rules.

Followup posts should go to linux-hotplug-devel@lists.sourceforge.net

-- Patrick Mansfield
