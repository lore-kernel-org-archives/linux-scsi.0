From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Wed, 17 Jan 2007 10:54:11 -0600
Message-ID: <1169052851.3416.18.camel@mulgrave.il.steeleye.com>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net>
	 <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no>
	 <45A69937.8030400@us.ibm.com> <45A6C33C.8060900@scanventure.no>
	 <45A81BBF.7050104@us.ibm.com> <45AA4A7B.7070607@scanventure.no>
	 <45ABE920.7090304@us.ibm.com>  <45ACDD6A.7040201@scanventure.no>
	 <1168989278.16470.22.camel@alexisLabtop> <45ADFFA8.5040702@scanventure.no>
	 <B7A62A39-ECD0-4A7E-8645-696F9D2F330C@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60751 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932524AbXAQQ4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 11:56:21 -0500
In-Reply-To: <B7A62A39-ECD0-4A7E-8645-696F9D2F330C@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@gmail.com>
Cc: Tarjei Huse <tarjei@scanventure.no>, Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi@vger.kernel.org, "Tan, Dennis" <Dennis_Tan@adaptec.com>, "Chim, Ed" <ed_chim@adaptec.com>, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>

On Wed, 2007-01-17 at 10:32 -0600, Mark Rustad wrote:
> Your initramfs needs to have hotplug scripts that can handle firmware  
> loading. I'm pretty sure that is what is missing, because I just went  
> through the same thing with a QLogic FC driver.

Yes, there was a patch for at least debian's mkinitrd to do all of this:

http://marc.theaimsgroup.com/?l=linux-kernel&m=115680315625712

James


