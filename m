From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Mon, 12 May 2003 11:18:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030512181852.GA3226@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com> <1052711864.1768.7.camel@mulgrave> <20030512063833.GA4133@beaverton.ibm.com> <1052761851.2093.55.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:34501 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262440AbTELSDo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 14:03:44 -0400
Content-Disposition: inline
In-Reply-To: <1052761851.2093.55.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> Also, eventually, don't we need to do class_device_remove_files() on the
> created class files, so that will have to be done in release and we've
> got symmetry problems again?
> 

I have been told that we you do not need to call
class_device_remove_files as the cleanup functionality of *_remove_files
happens implicitly through the call to sysfs_remove_dir. I will verify
this.

If we needed to add this back in we would add it to scsi_sysfs_remove_host
as they are created in scsi_sysfs_add_host.

-andmike
--
Michael Anderson
andmike@us.ibm.com

