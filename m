From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: threads scsi_eh_ and scsi_tmf_ don't die when ib_srp reconnect
Date: Fri, 14 Aug 2015 09:10:09 -0700
Message-ID: <55CE12E1.6030707@sandisk.com>
References: <55C8C0DC.7070505@clodo.ru> <55C8C39B.1010000@sandisk.com>
 <55C9FB62.1030004@clodo.ru> <55CA5AD4.8080109@sandisk.com>
 <55CAD674.4040104@clodo.ru> <55CB796D.3030709@sandisk.com>
 <55CDAF7D.3050301@clodo.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:62112
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754304AbbHNQKP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2015 12:10:15 -0400
In-Reply-To: <55CDAF7D.3050301@clodo.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "kkv@clodo.ru" <kkv@clodo.ru>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/14/2015 02:06 AM, Konstantin Krotov wrote:
> I tested the patch, the problem is not reproduced.

Thanks for confirming that the patch fixes this issue. I will send a 
slightly modified version of this patch soon to the Linux RDMA maintainer.

Bart.
