From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 4/7] scsi/qla_os: replace schedule_timeout() with
	ssleep()
Date: Wed, 12 Jan 2005 10:32:11 -0600
Message-ID: <1105547532.5577.18.camel@mulgrave>
References: <20050111232257.909231F226@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:51857 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261239AbVALQcY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 11:32:24 -0500
In-Reply-To: <20050111232257.909231F226@trashy.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, nacc@us.ibm.com

On Wed, 2005-01-12 at 00:22 +0100, domen@coderock.org wrote:
> Description: Use ssleep() instead of schedule_timeout() to guarantee the
[...]
> -		set_current_state(TASK_UNINTERRUPTIBLE);
> -		schedule_timeout(ABORT_POLLING_PERIOD);
> +		msleep(ABORT_POLLING_PERIOD);

The description doesn't match the code.

Also, the qla driver is maintained.  You should cc
andrew.vasquez@qlogic.com (I know they don't make it easy, like having
an entry in the MAINTAINERS file or even an email address in the code).

James


