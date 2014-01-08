From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Tue, 07 Jan 2014 17:35:13 -0800
Message-ID: <laia05$vmq$1@ger.gmane.org>
References: <52CC944C.50702@gmail.com> <20140108004724.GA14082@xanatos>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010801090107060700070401"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33756 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbaAHBfe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jan 2014 20:35:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1W0i3O-0003p0-Qh
	for linux-scsi@vger.kernel.org; Wed, 08 Jan 2014 02:35:30 +0100
Received: from adsl-69-234-184-8.dsl.irvnca.pacbell.net ([69.234.184.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2014 02:35:30 +0100
Received: from w41ter by adsl-69-234-184-8.dsl.irvnca.pacbell.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2014 02:35:30 +0100
In-Reply-To: <20140108004724.GA14082@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-usb@vger.kernel.org

This is a multi-part message in MIME format.
--------------010801090107060700070401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/07/2014 04:47 PM, Sarah Sharp wrote:
> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
>> On 01/07/2014 01:21 PM, Sarah Sharp wrote:
>>
>>> Can you please try the attached patch, on top of the previous three
>>> patches, and send me dmesg?
>>
>> Hi Sarah, I just now finished running 0001-More-debugging.patch for the
>> first time.  The previous dmesg didn't include that patch, but this one
>> does.
 
> Well, it has all the info I need, but the results don't make me too
> happy. 

Ouch.  Sorry :/

> Can you send me the output of `sudo lspci -vvv -n`?  Maybe we can just
> turn off scatter-gather for your host controller until we get a proper
> fix in that uses link TRBs instead of no-op TRBs.

Attached.

--------------010801090107060700070401
Content-Type: application/gzip;
 name="lspci.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lspci.gz"

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

--------------010801090107060700070401--

