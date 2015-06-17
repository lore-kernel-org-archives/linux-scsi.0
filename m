From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v1 02/20] [SCSI] mpt3sas: Get IOC_FACTS information using
  handshake protocol only after HBA card gets into READY or Operational state.
Date: Wed, 17 Jun 2015 13:27:43 +0200
Message-ID: <558159AF.5020604@redhat.com>
References: <1434532251-6897-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864AbbFQL1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2015 07:27:48 -0400
In-Reply-To: <1434532251-6897-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, jthumshirn@suse.de, joe.lawrence@stratus.com

On 06/17/2015 11:10 AM, Sreekanth Reddy wrote:
> Driver initialization fails if driver tries to send IOC facts request message when the IOC is in reset or in a fault state.
> 
> This patch will make sure that
>  1.Driver to send IOC facts request message only if HBA is in operational or ready state.
>  2.If IOC is in fault state, a diagnostic reset would be issued.
>  3.If IOC is in reset state then driver will wait for 10 seconds to exit out of reset state.
>    If the HBA continues to be in reset state, then the HBA wouldn't be claimed by the driver.
> 
> Changes in v1:
>    If PCI Recovery is on then return with -EFAULT in the function _base_wait_for_iocstate().
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

