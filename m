From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [V3 PATCH 5/9] csiostor: Chelsio FCoE offload driver submission
 (sources part 5).
Date: Wed, 12 Sep 2012 11:10:53 +0530
Message-ID: <50502065.1090807@chelsio.com>
References: <1347374347-3852-1-git-send-email-naresh@chelsio.com> <1347374347-3852-6-git-send-email-naresh@chelsio.com> <20120911.133510.1351483747174862495.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:30044 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2ILFlI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Sep 2012 01:41:08 -0400
In-Reply-To: <20120911.133510.1351483747174862495.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dimitrios Michailidis <dm@chelsio.com>, Casey Leedom <leedom@chelsio.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Chethan Seshadri <chethan@chelsio.com>

On 9/11/2012 11:05 PM, David Miller wrote:
> From: Naresh Kumar Inna <naresh@chelsio.com>
> Date: Tue, 11 Sep 2012 20:09:03 +0530
> 
>> +#include <linux/moduleparam.h>
> 
> This header include is not necessary.
> 

I will remove it, thanks.
