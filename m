From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [PATCH 0/8] csiostor: Chelsio FCoE offload driver submission
Date: Sun, 26 Aug 2012 00:38:48 +0530
Message-ID: <503922C0.7000707@chelsio.com>
References: <1345760873-12101-1-git-send-email-naresh@chelsio.com> <20120824.130406.1059160453285824849.davem@davemloft.net> <5037D043.7000302@chelsio.com> <20120824.151008.248026066556198861.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:9492 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2HYTJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Aug 2012 15:09:05 -0400
In-Reply-To: <20120824.151008.248026066556198861.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dimitrios Michailidis <dm@chelsio.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Chethan Seshadri <chethan@chelsio.com>

On 8/25/2012 12:40 AM, David Miller wrote:
> From: Naresh Kumar Inna <naresh@chelsio.com>
> Date: Sat, 25 Aug 2012 00:34:35 +0530
> 
>> Thanks for reviewing. Is your comment with respect to any particular
>> module parameter[s] in this driver or all of them?
> 
> All of them.
> 

So are module parameters being obsoleted? You mentioned about using
generic kernel facilities for tuning driver knobs. Could you please
elaborate a bit more?

Thanks,
Naresh.
