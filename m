From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: aha1542: rework locking
Date: Tue, 21 Apr 2015 14:41:55 +0300
Message-ID: <20150421114155.GG16501@mwanda>
References: <20150421092603.GC12098@mwanda>
 <201504211239.40423.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34444 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbDULmK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 07:42:10 -0400
Content-Disposition: inline
In-Reply-To: <201504211239.40423.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Apr 21, 2015 at 12:39:40PM +0200, Ondrej Zary wrote:
> Thanks, I missed that as it was already wrong before (since at least when
> DEF_SCSI_QCMD was introduced). And it worked despite that.

If you turn on CONFIG_DEBUG_ATOMIC_SLEEP=y it will generate a warning
splat.  Otherwise you probably have to get very unlucky for this to
deadlock.

> 
> Should I just change that to GFP_ATOMIC?

The other option is to do the allocation before taking the lock.  That
looks do-able.  You are the expert here by virtue of you touched to code
last.  So you get to decide.  :)

regards,
dan carpenter

