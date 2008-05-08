From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Strange mptbase / mptscsih kernel messages
Date: Thu, 8 May 2008 01:27:12 -0700
Message-ID: <20080508012712.2d714dcf.akpm@linux-foundation.org>
References: <e2e108260805072336p6b29f11o287ac3c5cab9295a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbYEHI1R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 04:27:17 -0400
In-Reply-To: <e2e108260805072336p6b29f11o287ac3c5cab9295a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

On Thu, 8 May 2008 08:36:03 +0200 "Bart Van Assche" <bart.vanassche@gmail.com> wrote:

> Hello,
> 
> I have made a setup with four servers, where each server is configured
> as follows:
> * Four Intel Xeon E5130 CPU cores.
> * 8 GB RAM.
> * SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
> PCI-Express Fusion-MPT SAS (rev 04),
> * 16 disks in a RAID6 setup (md).
> * Linux 2.6.24.6 kernel.
> 
> There is a lot of data being written to the RAID6 array: about 50 MB/s
> on each server. There are two kinds of messages that appear:
> 
> (1)
> [74887.117650] mptbase: ioc0: LogInfo(0x31120403): Originator={PL},
> Code={Abort}, SubCode(0x0403)
> 
> (2)
> [74917.081454] mptscsih: ioc0: attempting task abort! (sc=ffff8100a18a7180)
> [74917.081461] sd 0:0:15:0: [sdp] CDB: Write(10): 2a 00 1c fe 61 93 00 00 20 00
> [74918.409801] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
> Code={IO Executed}, SubCode(0x0000)
> [74918.639801] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8100a18a7180)
> 
> These messages appear a few times per day. Anyone any idea what the
> meaning is of these messages and what the cause of these messages is ?
> 

(suitable cc's added)

