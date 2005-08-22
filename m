From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 22 Aug 2005 14:53:16 -0700
Message-ID: <20050822215316.GB8083@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050822045502.GA7147@lists.us.dell.com> <430A05F2.10009@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:30917 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750743AbVHVVxt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 17:53:49 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7MLrkf5357868
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 17:53:47 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7MLrth5353952
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 15:53:55 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7MLrjpF023211
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 15:53:46 -0600
Content-Disposition: inline
In-Reply-To: <430A05F2.10009@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> Yes, that's cool.
> 
> How about specifying the LU label _and_ the FS label to "root="?
> 
> root=[<disk label>:]<fs label>
> 
> <disc label> :=
> 	WWN,
> 	HCIL,
> 	Funky name 1,
> 	Funky name 2.
> 
> <fs label> :=
> 	filesystem specific label.
> 	
> All those labels are tacked onto the LU, and are provided by
> various layers: transport, LLDD, vendor, manufacturer, etc, etc, etc.
> 

What is the difference between this disk label and what you can do with a
udev rules file today? On SUSE today you can boot a system using a udev
created name "root=/dev/disk/by-id/351234560000007d0" which is one example
of using the udev rules "PROGRAM" call to generate a name. You should be
able to cover all your examples with a call-out program knowledgeable of
where to find this disk label information and create a device node for
them.

-andmike
--
Michael Anderson
andmike@us.ibm.com
