From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [Patch V2 4/9] [SCSI] aacraid: Enable 64-bit write to controller
  register
Date: Thu, 25 Jun 2015 18:03:32 +0200
Message-ID: <558C2654.5090204@redhat.com>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com> <1433986951-9033-6-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbbFYQDf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2015 12:03:35 -0400
In-Reply-To: <1433986951-9033-6-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On 06/11/2015 03:42 AM, rajinikanth.pandurangan@pmcs.com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> 
> Description:
>         If writeq() not supported, then do atomic two 32bit write
> 
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Tomas

