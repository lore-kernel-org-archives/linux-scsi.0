From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 2/7] scsi/ppa: replace schedule_timeout() with msleep()
Date: Wed, 12 Jan 2005 10:24:50 -0600
Message-ID: <1105547090.5577.13.camel@mulgrave>
References: <20050111232251.3BBB31F226@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29320 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261229AbVALQZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 11:25:09 -0500
In-Reply-To: <20050111232251.3BBB31F226@trashy.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, nacc@us.ibm.com, janitor@sternwelten.at

On Wed, 2005-01-12 at 00:22 +0100, domen@coderock.org wrote:
> -		schedule_timeout(3 * HZ);
> +		msleep(3000);

This would make more sense as ssleep(3), wouldn't it?

James


