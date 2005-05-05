From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 2/3] add open iscsi netlink interface to iscsi
 transport class
Date: Thu, 05 May 2005 18:55:03 +0900 (JST)
Message-ID: <20050505.185503.78606493.yoshfuji@linux-ipv6.org>
References: <42798AC1.2010308@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yue.linux-ipv6.org ([203.178.140.15]:60422 "EHLO
	yue.st-paulia.net") by vger.kernel.org with ESMTP id S262005AbVEEJwZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 May 2005 05:52:25 -0400
In-Reply-To: <42798AC1.2010308@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, netdev@oss.sgi.com, linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org

In article <42798AC1.2010308@cs.wisc.edu> (at Wed, 04 May 2005 19:53:53 -0700), Mike Christie <michaelc@cs.wisc.edu> says:

> +struct iscsi_uevent {
:
> +} __attribute__ ((aligned (sizeof(unsigned long))));

I think it'd be better to use sizeof(uint64_t) or something.
Please check other spots, too. e.g.:

> +	struct iscsi_stats_custom custom[0]
> +		__attribute__ ((aligned (sizeof(unsigned long))));

--yoshfuji
