From: "Moore, Eric Dean" <emoore@lsil.com>
Subject: Re: Fusion-MPT with 53C1030 and no flash?
Date: Fri, 8 Oct 2004 21:50:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000c01c4adb3$19aac630$1a1015ac@ericmoore>
References: <BBB2B829DCAA204D9BA39DAE37CD05A1630FEF@mail01.midstream.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9133 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266362AbUJIDvM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2004 23:51:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: Brian Eng <brian@midstream.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Friday, October 08, 2004 12:57 PM, Matthew Dharm wrote:

> Has anyone ever used an LSI 53C1030 chip WITHOUT attached flash?

Yes this works. In embedded environment w/o flash, the firmware is
packaged with the system bios, and downloaded to the part via the 1030
option rom.

>
> As I read the technical docs, it's possible... but it requires a driver
> which can download the firmware to the ARM processor.  It looks like the
> current 2.6.x driver can't do that.
>

Look at mpt_downloadboot in mptbase.c
http://lxr.linux.no/source/drivers/message/fusion/mptbase.c?v=2.6.8.1


> In fact, I can't seem to locate a suitable firmware image anywhere...
>

http://www.lsilogic.com/downloads/selectDownload.do
Step 1: Storage Adapters
Step 2: Ultra 320 Host Bus Adapters
Step 3: LSI 22320-R


Eric Moore
LSI Logic


