From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Transport affected timeouts...
Date: 16 Apr 2004 14:24:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082143462.1807.31.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C0169E@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:10369 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263613AbUDPTYZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 15:24:25 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C0169E@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Fri, 2004-04-16 at 10:40, Smart, James wrote:
> One issue that we're wrestling with in our driver is timeout values. In the
> past, we've encountered large configurations where the timeouts from the
> midlayer are insufficient. In general - we'd like the scsi host to be able
> to add a transport/topology increment time to the base timeout values.  The
> methodology would have to be dynamic as it may change as link connectivity
> changes.
> 
> Obviously, an hba driver mucking with the timeout values handed to it is
> frowned upon. Is there a recommendation on how we should handle this ?

There's no currently agreed upon framework, but would

http://www-124.ibm.com/storageio/ipr/patch-2.6.5-sd_timeout_mod

Do for what you want?

James


