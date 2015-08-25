From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 02/10] [SCSI] aacraid: Add Power Management support
Date: Tue, 25 Aug 2015 15:41:56 +0200
Message-ID: <55DC70A4.9070808@redhat.com>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1439272701-15344-3-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbbHYNl7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 09:41:59 -0400
In-Reply-To: <1439272701-15344-3-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

On 11.8.2015 07:58, Mahesh Rajashekhara wrote:
> Description:
> 	* .suspend() and .resume() routines implemented in the driver
> 	* aac_release_resources() initiates firmware shutdown
> 	* aac_acquire_resources re-initializes the host interface
> 
> Changes from V2:
> Increased msleep(1) to msleep(20)
> Reverted pci_enable_msix_exact() to pci_enable_msix() as this change has moved into a separate patch.
> 
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

