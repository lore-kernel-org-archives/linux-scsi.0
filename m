From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_status() macro
Date: 15 May 2003 20:11:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053047480.3998.120.camel@mulgrave>
References: <3EC427D5.3060309@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:59143 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264325AbTEPA7L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 20:59:11 -0400
In-Reply-To: <3EC427D5.3060309@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

If you're doing this:

On Thu, 2003-05-15 at 18:50, Douglas Gilbert wrote:
> +#define scsi_status(result) ((result) & 0x7e)

because bit0 is reserved in SCSI-2, then it should be 0x3e because bits
6 and 7 are also reserved.  Of course, this would clash with the SCSI-3
definition of TASK ABORTED, sigh.

Perhaps it's better just not to bother with the mask?

James


