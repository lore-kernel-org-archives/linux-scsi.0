From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: sniffing scsi
Date: Sun, 19 Feb 2012 10:25:54 +0000
Message-ID: <CAO+b5-pu7sj8UH4qW_WRkcG74t2BzeVmHj7Aug036dQPCxzANQ@mail.gmail.com>
References: <CAAMvbhEcheTpAU1kX9nR=D+p3X6uWCu1uXEr6xaH3Wuezpcn+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41419 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab2BSKZ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Feb 2012 05:25:56 -0500
Received: by wgbdt10 with SMTP id dt10so3914409wgb.1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Feb 2012 02:25:54 -0800 (PST)
In-Reply-To: <CAAMvbhEcheTpAU1kX9nR=D+p3X6uWCu1uXEr6xaH3Wuezpcn+g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Jan 15, 2012 at 11:54 AM, James Courtier-Dutton
<james.dutton@gmail.com> wrote:
> Is it possible to monitor scsi messages on a particular bus.
> E.g. Attach to /dev/sda or /dev/sr0 and capture all messages going between them.
> Ideally, in such a way that wireshark can capture it.
> We can do this for Ethernet and USB, but I cannot find SCSI bus capture.

Depends on the SCSI bus type. CDBs without transport information do
not provide enough information for SCSI transports supporting I/O
depth > 1. As far as I know the only SCSI transport type currently
supported by Wireshark is iSCSI. The first step when adding support
for another SCSI transport would be to define a new libpcap link-layer
header type. See also http://www.tcpdump.org/linktypes.html.

Bart.
