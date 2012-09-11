From: David Miller <davem@davemloft.net>
Subject: Re: [V3 PATCH 5/9] csiostor: Chelsio FCoE offload driver
 submission (sources part 5).
Date: Tue, 11 Sep 2012 13:35:10 -0400 (EDT)
Message-ID: <20120911.133510.1351483747174862495.davem@davemloft.net>
References: <1347374347-3852-1-git-send-email-naresh@chelsio.com>
	<1347374347-3852-6-git-send-email-naresh@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:45709 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2IKRfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2012 13:35:12 -0400
In-Reply-To: <1347374347-3852-6-git-send-email-naresh@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: naresh@chelsio.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, dm@chelsio.com, leedom@chelsio.com, netdev@vger.kernel.org, chethan@chelsio.com

From: Naresh Kumar Inna <naresh@chelsio.com>
Date: Tue, 11 Sep 2012 20:09:03 +0530

> +#include <linux/moduleparam.h>

This header include is not necessary.
