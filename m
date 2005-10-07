From: Olaf Hering <olh@suse.de>
Subject: Re: bad error handling in lpfc in 2.6.13
Date: Fri, 7 Oct 2005 14:07:07 +0200
Message-ID: <20051007120707.GB32661@suse.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7AE0@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:61143 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932378AbVJGMHN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2005 08:07:13 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7AE0@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, olof@austin.ibm.com, benh@kernel.crashing.org

 On Thu, Oct 06, James.Smart@Emulex.Com wrote:

> Patches were submitted to bring the driver up to rev 8.0.30, which was not
> pulled mainstream until 2.6.14-rc1 (or rc2). Please ensure you are running
> this driver. Note: a tarball with the sources, functional on 2.6.12/2.6.13
> can be found on sourceforge
> (http://sourceforge.net/project/showfiles.php?group_id=103050&package_id=110636)

Another thing I found today, sdb, sdc, sdd and sde did all map to the
very same "disk" on the other end, with 2.6.13.

I see this in dmesg:

<3>lpfc 0001:58:01.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
<3>lpfc 0001:58:01.0: 0:1303 Link Up Event x1 received Data: x1 x1 x4 x0

Will try the newer driver version and see how it goes.

> As for the error - Hardware error is a bad thing. Actually, we're already 
> rewriting the driver to deal with hardware errors that fail attach, such as
> this. It will be in our next release. Note that we also encountered an oops
> in the host midlayer, where a call to scsi_host_put is called directly after
> scsi_host_alloc, w/o an intervening scsi_host_add. We'll look throught the
> additional traces below and see if we see something.

I will move the card to another box and see how it goes. I heard the
p520 we have is pre-GA level.

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
