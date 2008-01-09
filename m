From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Number of devices that SCSI can support
Date: Tue, 8 Jan 2008 19:22:33 -0700
Message-ID: <20080109022233.GM16309@parisc-linux.org>
References: <404714.86520.qm@web43145.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58781 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYAICWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 21:22:34 -0500
Content-Disposition: inline
In-Reply-To: <404714.86520.qm@web43145.mail.sp1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 08, 2008 at 04:55:46PM -0800, Vinay Venkataraghavan wrote:
> Is there a limit on the number of devices that SCSI supports. In other words, I have a QLogic HBA card, and I am connecting to a SAN which has 64 targets. 

I've personally had over five hundred LUNs.  You shouldn't be hitting a
limit here.

> I am running 2.6.9-42. 

That sounds like a Red Hat Enterprise kernel.  Perhaps you should
contact them for support?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
