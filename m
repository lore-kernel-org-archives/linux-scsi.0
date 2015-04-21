From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 17/18] megaraid_sas : fix megasas_fire_cmd_fusion
 calling convention
Date: Tue, 21 Apr 2015 14:24:23 +0200
Message-ID: <55364177.6080509@redhat.com>
References: <201504201237.t3KCbMCa016895@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbbDUMYv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 08:24:51 -0400
In-Reply-To: <201504201237.t3KCbMCa016895@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:35 PM, Sumit.Saxena@avagotech.com wrote:
> The fusion HBAs don't really use the instance template like the other
> variants, as it branches off at a much higher level.  So instead of
> trying to squeeze megasas_fire_cmd_fusion into the wrong calling
> convention call it locally with argument data types that match what
> is passed.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

