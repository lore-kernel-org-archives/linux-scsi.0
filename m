From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI: Don't be so verbose if no disc is present
Date: Fri, 9 Sep 2005 15:35:41 -0700
Message-ID: <20050909223541.GA25458@us.ibm.com>
References: <432209EC.90900@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40612 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932606AbVIIWfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 18:35:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j89MZjbN007102
	for <linux-scsi@vger.kernel.org>; Fri, 9 Sep 2005 18:35:45 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j89MZibX105404
	for <linux-scsi@vger.kernel.org>; Fri, 9 Sep 2005 18:35:45 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j89MZiQe029462
	for <linux-scsi@vger.kernel.org>; Fri, 9 Sep 2005 18:35:44 -0400
Content-Disposition: inline
In-Reply-To: <432209EC.90900@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Hi ... did you try James' patch? Looks like the same problem.

Patch here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112585164819923&w=2

Was hidden within some other thread ...

On Fri, Sep 09, 2005 at 11:17:16PM +0100, Daniel Drake wrote:
> Running a simple "touch /dev/scd0" on a SCSI cdrom will cause the following 
> message to appear in the logs if no disc is present:
> 
> 	Device not ready. Make sure there is a disc in the drive.
> 
> This results in the logs being flooded for some users by those userspace 
> agents which repeatedly poll the device for media change.
> 
> This patch demotes the message to a quieter scsi-logging message only.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
> 
