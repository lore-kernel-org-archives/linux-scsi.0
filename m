From: Douglas Gilbert <dougg@torque.net>
Subject: Re: 2.6.0 stability and the BK scsi trees
Date: Thu, 16 Oct 2003 21:56:54 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F8E8786.2020502@torque.net>
References: <1066265974.16761.426.camel@fuzzy>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:13235 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S262878AbTJPL57
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2003 07:57:59 -0400
In-Reply-To: <1066265974.16761.426.camel@fuzzy>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> In the light of the recently announced "bug fixes only" edict for the
> 2.6 kernel, I'll be splitting our current SCSI BK tree:

Ok, I'll bite:-)

What was the point of putting 32 dev_t's into the
kernel? Many people who were advocating it used
the increased number of scsi disks (> 256) and
partitions (from 15 to 63 [to match the ide subsystem])
as a major reason.

The sd driver is still littered with hacks to distribute
its 256 (max) disks over 8 majors. Shouldn't this be
fixed?

Comments?

Doug Gilbert

