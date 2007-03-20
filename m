From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Tue, 20 Mar 2007 11:58:19 -0500
Message-ID: <1174409899.3522.16.camel@mulgrave.il.steeleye.com>
References: <20070320150718.GF6152@htj.dyndns.org>
	 <20070320151359.GG6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47677 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965323AbXCTQ6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 12:58:30 -0400
In-Reply-To: <20070320151359.GG6152@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br

On Wed, 2007-03-21 at 00:13 +0900, Tejun Heo wrote:
> Implement SBC START/STOP management.  sdev->mange_start_stop is added.
> When it's set to one, sd STOPs the device on suspend and shutdown and
> STARTs it on resume.  sdev->manage_start_stop defaults is in sdev
> instead of scsi_disk cdev to allow ->slave_config() override the
> default configuration but is exported under scsi_disk sysfs node as
> sdev->allow_restart is.
> 
> When manage_start_stop is zero (the default value), this patch doesn't
> introduce any behavior change.

I have this in scsi-misc-2.6.  There was a minor space before tab no-no
which git complained about (and I fixed).  Unfortunately, there's a
pretty major merge conflict with prior sd.c patches in scsi-misc-2.6.
I've merged and fixed this but it's going to create a bit of a
difficulty for applying the libata pieces.

James


