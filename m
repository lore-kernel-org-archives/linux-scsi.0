From: Olaf Hering <olaf@aepfle.de>
Subject: Re: use dedicated storage for scsi_debug LUNs
Date: Fri, 6 Mar 2015 10:11:28 +0100
Message-ID: <20150306091128.GA30096@aepfle.de>
References: <20150305153338.GA16293@aepfle.de>
 <54F8C923.5010202@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:31595 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbCFJLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 04:11:30 -0500
Content-Disposition: inline
In-Reply-To: <54F8C923.5010202@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 05, Douglas Gilbert wrote:

> So it is possible. The stock answer has typically been that
> you should probably be using the target subsystem for that.
> Thoughts?

Is the target subsystem capable of stacking? What I need for
xen-scsiback is a bunch of true SCSI devices. Due to lack of hardware,
scsi_debug looks like the obvious choice.

I will see if I can come up with a patch. Thanks for your input.

Olaf
