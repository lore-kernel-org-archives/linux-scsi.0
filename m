From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 09/10] [SCSI] aacraid: Replace pci_enable_msix() with
 pci_enable_msix_range()
Date: Tue, 25 Aug 2015 17:06:38 +0200
Message-ID: <55DC847E.9050806@redhat.com>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1439272701-15344-10-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbbHYPGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 11:06:42 -0400
In-Reply-To: <1439272701-15344-10-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

On 11.8.2015 07:58, Mahesh Rajashekhara wrote:
> Description:
> 	As pci_enable_msix() deprecated, replaced with pci_enable_msix_range()
>
> Changes from V5:
> Merged 10 and 11 of V5 into this patch.
> AAC_MAX_MSIX definition change.
>
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

