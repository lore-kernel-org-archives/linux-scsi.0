From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: OOPS: While logging out of iSCSI Session when MultiPath is Enabled
Date: Thu, 18 Jun 2015 21:07:40 -0700
Message-ID: <5583958C.8050009@sandisk.com>
References: <CAJRCtXdLkC_Ywmy+ypcdF4iYfMmzbLbpzAwirTjp3LKkQBm3-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:55584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750721AbbFSEHr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 00:07:47 -0400
In-Reply-To: <CAJRCtXdLkC_Ywmy+ypcdF4iYfMmzbLbpzAwirTjp3LKkQBm3-g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sony John <sony.john@avagotech.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 06/18/15 08:50, Sony John wrote:
> We had logged in to the same target through two NIC interfaces. There
> were 2 iSCSI-Session and multipath -ll showed the details fine.
>
> The moment we issue logout command on both the session the below
> kernel panic happens. If multipath is disabled there is no panic and
> everything works fine.

A similar issue had been reported some time ago on the dm-devel mailing 
list but should already have been fixed in a later v4.1 rc version. 
Please retest with v4.1-rc8 or later.

Thanks,

Bart.

