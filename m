From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 02/23] scsi_dh_alua: separate out alua_stpg()
Date: Thu, 11 Feb 2016 15:54:20 -0800
Message-ID: <56BD1F2C.8070209@sandisk.com>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
 <1454942086-128704-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0077.outbound.protection.outlook.com ([157.56.111.77]:6242
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751046AbcBKXyY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2016 18:54:24 -0500
In-Reply-To: <1454942086-128704-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>

On 02/08/2016 06:34 AM, Hannes Reinecke wrote:
> + * alua_stpg - Issue a SET TARGET GROUP STATES command
> + *
> + * Issue a SET TARGET GROUP STATES command and evaluate the

Hello Hannes,

Please change the two references to STPG into "SET TARGET PORT GROUP" 
such that the description matches SPC-4 and also the description of this 
patch.

Bart.
