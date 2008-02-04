From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Mon, 04 Feb 2008 12:15:51 -0800
Message-ID: <1202156151.13537.14.camel@linuxchandra>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
	 <1202151498.3096.84.camel@localhost.localdomain>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:37751 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbYBDUP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:15:58 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m14KFrGU026951
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 15:15:53 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m14KFr6j194110
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 13:15:53 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m14KFqio029692
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2008 13:15:53 -0700
In-Reply-To: <1202151498.3096.84.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, michaelc@cs.wisc.edu, jens.axboe@oracle.com

On Mon, 2008-02-04 at 12:58 -0600, James Bottomley wrote:
> On Wed, 2008-01-23 at 16:32 -0800, Chandra Seetharaman wrote:
> > Subject: scsi_dh: Add support for SDEV_PASSIVE
> > 
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > This patch adds a new device state SDEV_PASSIVE, to correspond to the
> > passive side access of an active/passive multipathed device.
> 
> Really, no; this isn't right.  The state field of a SCSI device is for
> the SCSI state model.  Passive might be a valid device mapper state, but

Hi James,

It is not the "device mapper state", it is the state of the device
itself. These devices have active/passive paths, the passive paths will
be represented by SDEV_PASSIVE device state in SCSI.

chandra
> it's not a valid SCSI state.  If these patches can't work except by
> mucking with the SCSI state model, there's some layering problem
> elsewhere that needs sorting out.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


