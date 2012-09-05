From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [V2 PATCH 6/9] csiostor: Chelsio FCoE offload driver submission
 (headers part 1).
Date: Wed, 5 Sep 2012 09:31:33 -0700
Message-ID: <20120905093133.5f97fcbb@nehalam.linuxnetplumber.net>
References: <1346848442-4573-1-git-send-email-naresh@chelsio.com>
	<1346848442-4573-7-git-send-email-naresh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:33225 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab2IEQcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2012 12:32:01 -0400
In-Reply-To: <1346848442-4573-7-git-send-email-naresh@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Naresh Kumar Inna <naresh@chelsio.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, dm@chelsio.com, leedom@chelsio.com, netdev@vger.kernel.org, chethan@chelsio.com

On Wed,  5 Sep 2012 18:03:59 +0530
Naresh Kumar Inna <naresh@chelsio.com> wrote:

> +#define CSIO_ROUNDUP(__v, __r)		(((__v) + (__r) - 1) / (__r))

This is similar to existing round_up() in kernel.h could you use that?
