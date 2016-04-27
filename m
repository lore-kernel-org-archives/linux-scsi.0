From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 07/12] scsi_debug: use likely hints on fast path
Date: Tue, 26 Apr 2016 22:33:11 -0700
Message-ID: <57204F17.3010605@sandisk.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-8-git-send-email-dgilbert@interlog.com>
 <571FE840.1010304@sandisk.com> <57204D37.3050302@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0073.outbound.protection.outlook.com ([65.55.169.73]:29312
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbcD0FdR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 01:33:17 -0400
In-Reply-To: <57204D37.3050302@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "tomas.winkler@intel.com" <tomas.winkler@intel.com>, "emilne@redhat.com" <emilne@redhat.com>

On 04/26/16 22:25, Douglas Gilbert wrote:
> Do all re-factorings of code need a patch description?

Describing all changes makes the job of a reviewer easier because if all 
changes have been described the reviewer only has to verify the changes 
against the patch description instead of additionally having to figure 
out the purpose of changes that have not been described.

Bart.

