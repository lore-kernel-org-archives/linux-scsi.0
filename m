From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: still BUG's for smp_processor_id() on interrupt
Date: Wed, 9 Feb 2005 10:26:01 -0800
Message-ID: <20050209182601.GA7023@us.ibm.com>
References: <0B1E13B586976742A7599D71A6AC733C12EB58@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e4.ny.us.ibm.com ([32.97.182.144]:28806 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261894AbVBIS1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2005 13:27:21 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j19IRC8k023274
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 13:27:12 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j19IRCCE228130
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 13:27:12 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j19IRBTl030565
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 13:27:12 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EB58@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, akpm@osdl.org

On Wed, Feb 09, 2005 at 01:13:44PM -0500, James.Smart@Emulex.Com wrote:
> This looks suspiciously like the oops trace that I saw when
> loading/unloading driver a couple of times. Make sure you have the
> following patches.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=110729104720492&w=2
> http://marc.theaimsgroup.com/?l=linux-scsi&m=110737816906830&w=2

Thanks James -

Yes, it was a driver reload (after applying Andrew V's patch, rmmod
qla2300 and then insmod qla2300).

I had found the second patch "fix the fix for multiple HBA problem with
transport" and verified it is in mainline. 

But missed the first one "fix HBA removal problem with transport classes",
plus it is NOT in mainline.

I applied and no more oops (and no BUGs using _smp_processor_id()).

-- Patrick Mansfield
