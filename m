From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: slow after upgrade to CentOS 5 (RHEL5)
Date: Sat, 27 Oct 2007 11:33:47 -0500
Message-ID: <1193502827.3281.9.camel@localhost.localdomain>
References: <471FEB81.80103@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58382 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752998AbXJ0Qdt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 12:33:49 -0400
In-Reply-To: <471FEB81.80103@verizon.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anthony Ewell <amewell@verizon.net>
Cc: linux-scsi@vger.kernel.org, bo yang <bo.yang@lsi.com>

On Wed, 2007-10-24 at 18:04 -0700, Anthony Ewell wrote:
> Hi All,
> 
>     If you all would not mind a post from the general
> public Linux user, after doing a complete disk wipe
> of CentOS 4 and installing CentOS5, my system is preceived
> to be 3 times slower.
> 
>      To troubleshooting this, I made a post on CentOS's
> bugzilla:  http://bugs.centos.org/view.php?id=2382
> 
>      Would some of the experts on this group mind
> looking at the bug to evaluate the possibility
> that it is being caused by the underlying scsi
> driver?   The post contains a dmesg from "Computer C".
> (Yes, I am getting a bit desperate.)

There's still too little information in the bug report to tell much of
anything.  The dmesg doesn't indicate any anomaly with the megaraid
(although the LSI people might be able to tell better).  However, it
also doesn't contain a trace of the tape drive.

Best guess would be a slow down in the megaraid driver.  Can you try
doing a speed test on it?  (hdparm -t should suffice).

James


