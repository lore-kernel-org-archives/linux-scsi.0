From: Marc Bevand <bevand_m@epita.fr>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.01 update
Date: Thu, 11 Mar 2004 20:13:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c2qdsq$lo5$1@sea.gmane.org>
References: <0E3FA95632D6D047BA649F95DAB60E57040DAD5A@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:5518 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S261680AbUCKTaL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 14:30:11 -0500
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1B1Vse-00072L-00
	for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 20:30:10 +0100
Received: from 212.180.104.242 ([212.180.104.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 20:30:08 +0100
Received: from bevand_m by 212.180.104.242 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 20:30:08 +0100
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57040DAD5A@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Moore, Eric Dean wrote:
> This is an update for the MPT Fusion drivers 2.6 kernel.
> Version 3.01.01.
> 
> This is a fix for poor performance in RAID Volumes. 
> The dvStatus was being cleared for hidden physical disks
> when mptscsih_slave_destroy is called.

Are these poor performances related to [1] (I encounter the same problem) ?
If so, do you plan to have a fix for the 2.4 kernel ? Thanks.

[1] http://testing.lkml.org/slashdot.php?mid=432911

-- 
Marc Bevand

