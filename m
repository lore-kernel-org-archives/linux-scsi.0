From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: DIF/DIX updates for 2.6.32
Date: Wed, 26 Aug 2009 14:54:22 +0300
Message-ID: <4A95226E.8030504@panasas.com>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:35094
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753834AbZHZMJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 08:09:37 -0400
In-Reply-To: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, Ihab.Hamadi@emulex.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On 08/26/2009 09:17 AM, Martin K. Petersen wrote:
> Updates to the DIF/DIX code for 2.6.32:
> 
>  - Add support for 32-byte CDBs to SCSI layer
> 
>  - Deprecate the DIX CONVERT ops
> 
>  - Detach pure DIF support from CONFIG_BLK_DEV_INTEGRITY
> 
>  - Add support for DIF Type 2 devices in sd
> 
>  - Add DIF Type 2 support to scsi_debug
> 

Hi Martin.

I have not followed your work very closely so please forgive me if
I'm asking dumb questions. I've meant to be asking you about something
for a while.

With an sd disk supporting DIF/DIX, do you have this problems?
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/5392
[Desynchronizing dm-raid1]

I know that we also have the above problem with iscsi and data-digest
such that when we come to sign the data it might change on us before
the target receives it.

(Personally I'm working on a Mirror system over osd's and will have to
 test for this problem as well. I anticipate a need to copy the data
 before submission like the dm-raid1 does)

Best regards
Boaz
