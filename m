From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/5] scsi_debug: increase the amount of ram that scsi_ram
 can allocate
Date: Sun, 30 Mar 2008 13:11:49 -0400
Message-ID: <47EFC9D5.8080107@torque.net>
References: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-relay1.uniserve.ca ([204.239.42.80]:57918 "EHLO
	smtp-relay1.uniserve.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYC3R2q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Mar 2008 13:28:46 -0400
In-Reply-To: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com

FUJITA Tomonori wrote:
> Currently, the maximum amount of RAM that scsi_debug can actually
> allocate is 4GB. This patchset increase it to 2TB.
> 
> Here's an example, scsi_debug allocates 6GB ram and exports it as if
> it were 6GB disk.
> 
> fujita@rose:/sys/bus/pseudo/drivers/scsi_debug$ cat virtual_gb
> 0
> fujita@rose:/sys/bus/pseudo/drivers/scsi_debug$ cat dev_size_mb
> 6144
> 
> scsi3 : scsi_debug, version 1.81 [20070104], dev_size_mb=6144, opts=0x0
> scsi 3:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
> sd 3:0:0:0: [sdc] 12582912 512-byte hardware sectors (6442 MB)
> 
> 
> This patchset also include minor cleanup.
> 
> This is against scsi-misc with the scsi_build_sense_buffer helper
> patchset and the scsi_debug lba fix:
> 
> http://marc.info/?l=linux-scsi&m=120640632301595&w=2
> 
> http://marc.info/?l=linux-scsi&m=120643343003171&w=2

For patches 1/5, 2/5, 3/5, 4/5 and 5/5 associated with this post:
Signed-off-by: Douglas Gilbert <dougg@torque.net>


Doug Gilbert
