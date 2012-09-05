From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [V2 PATCH 6/9] csiostor: Chelsio FCoE offload driver submission
 (headers part 1).
Date: Wed, 5 Sep 2012 22:56:14 +0530
Message-ID: <50478B36.6000103@chelsio.com>
References: <1346848442-4573-1-git-send-email-naresh@chelsio.com> <1346848442-4573-7-git-send-email-naresh@chelsio.com> <20120905093133.5f97fcbb@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:32413 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab2IER0Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Sep 2012 13:26:25 -0400
In-Reply-To: <20120905093133.5f97fcbb@nehalam.linuxnetplumber.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dimitrios Michailidis <dm@chelsio.com>, Casey Leedom <leedom@chelsio.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Chethan Seshadri <chethan@chelsio.com>

On 9/5/2012 10:01 PM, Stephen Hemminger wrote:
> On Wed,  5 Sep 2012 18:03:59 +0530
> Naresh Kumar Inna <naresh@chelsio.com> wrote:
> 
>> +#define CSIO_ROUNDUP(__v, __r)		(((__v) + (__r) - 1) / (__r))
> 
> This is similar to existing round_up() in kernel.h could you use that?
> 
I will replace it with round_up() if it serves the same purpose. Thanks.
