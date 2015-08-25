From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 03/10] [SCSI] aacraid: Change interrupt mode to MSI for
 series-6 controller
Date: Tue, 25 Aug 2015 15:50:00 +0200
Message-ID: <55DC7288.9040001@redhat.com>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1439272701-15344-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbbHYNuD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 09:50:03 -0400
In-Reply-To: <1439272701-15344-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

On 11.8.2015 07:58, Mahesh Rajashekhara wrote:
> Description:
> 	This change always sets MSI interrupt mode for series-6 controller.
> 
> Changes from V2:
> aac_msi option description and subject change.
> 
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
