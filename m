From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Transport affected timeouts...
Date: 16 Apr 2004 14:46:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082144808.1807.43.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C016A7@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:52354 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263174AbUDPTqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 15:46:54 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C016A7@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Fri, 2004-04-16 at 14:39, Smart, James wrote:
> I had looked at the patch.  I don't think it works as well as the
> incrementer. But it would be a start. We would need the st driver, and scsi
> generic to use it as well. It doesn't address the timeout changing post
> slave_configure. The other thing that bothers me is that it uses an explicit
> value. As per the thread, it would have been better to know what the
> original default was and just increment/double it - and there is the issue
> of different device types needing different defaults.

I don't think it's a good idea to alter *every* timeout, merely the
usual ones (hence, really only read and write in the patch).

Why do you need it to be variable post slave_configure?

James


