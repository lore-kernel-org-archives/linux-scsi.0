From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: SMART causes disks to go offline on an LSI SAS 1068 controller
Date: Tue, 15 Sep 2009 10:34:44 +1200
Message-ID: <4AAEC504.2030203@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:56500 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468AbZINW4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2009 18:56:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Gabor Gombas wrote:

 > I'm having problems when using smartmontools with SATA disks behind an
 > LSI SAS controller. The machine is a Dell PowerEdge 1950-II, the
 > controller in question:

<snip>

 > Is this a kernel bug (2.6.22 at least did not drop the disks), or a 
bug in smartmontools?

It is possibly a smartmontools build issue - it does not like -pie or 
-fpie compiler flags.

See: https://bugzilla.redhat.com/show_bug.cgi?id=452389

and I reported it on the smartmontools list, but there was no resolution 
that I am aware of.

Regards,

Richard
