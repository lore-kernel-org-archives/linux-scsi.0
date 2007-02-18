From: Mario Giammarco <mgiammarco-ml@4warding.com>
Subject: Re: LSI Logic 40919o fibre channel: scsi works ip not
Date: Sun, 18 Feb 2007 12:15:32 +0100
Message-ID: <45D83554.1080309@4warding.com>
References: <200702152306.25374.mgiammarco-ml@4warding.com> <F6F6225F9738D94FB5B5876E3707A9190112A445@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp01.kpnqwest.it ([212.97.32.22]:3031 "EHLO
	smtp01.kpnqwest.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223AbXBRLPz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Feb 2007 06:15:55 -0500
In-Reply-To: <F6F6225F9738D94FB5B5876E3707A9190112A445@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shirron, Stephen" <Stephen.Shirron@lsi.com>, linux-scsi@vger.kernel.org
Cc: "Hickerson, Roger" <Roger.Hickerson@lsi.com>

Shirron, Stephen ha scritto:
> Hi Mario,
> 
> Can you tell me what firmware version you have on your 40919
> card(s)?  The easiest way is to "cat /proc/mpt/summary".

This is summary:
ioc0: LSIFC919, FwRev=02000f00h, Ports=1, 
MaxQ=1023,LanAddr=00:06:2B:07:FA:10, IRQ=209


> 
> How often do the errors occur?  dmesg provides no timestamps,
> while /var/log/messages does.
> 
Sorry but in messagese there is not this error. I can say you that the 
frequency of the error is proportional to data transferred. If I start a 
n ftp dmesg output goes crazy.

I have seen this in /var/log/messages (sorry no timestamps again):


Fusion MPT LAN driver 3.04.01
mptlan: ioc0: PortNum=0, ProtocolFlags=0Fh (ITLB)
mptlan: ioc0: Fusion MPT LAN device registered as 'fc0'
mptlan: ioc0/fc0: LanAddr = 00:06:2B:07:FA:10
mptlan: ioc0/fc0: interface up & active
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003




