From: Lincoln Dale <ltd@cisco.com>
Subject: Re: LUN resizing
Date: Wed, 26 Nov 2003 06:34:05 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20031126063322.03273eb0@171.71.163.14>
References: <1069708054.26088.127.camel@lt-sv>
 <1069708054.26088.127.camel@lt-sv> <1069774983.2061.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:56960 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S263062AbTKYTeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 14:34:13 -0500
In-Reply-To: <1069774983.2061.28.camel@mulgrave>
References: <1069708054.26088.127.camel@lt-sv>
 <1069708054.26088.127.camel@lt-sv>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Stefan Voelkel <Stefan.Voelkel@millenux.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

At 02:43 AM 26/11/2003, James Bottomley wrote:
>You simply do
>
>echo 1 > /sys/bus/scsi/<device>/rescan
>
>It will re-read the capacity and partition table (as long as the device
>is unmounted and none of the partitions open).

i guess that kinda defeats the purpose of online resizing; the idea is that 
the partitions DO remain mounted and the partitions with a refcount against 
them!


cheers,

lincoln.

