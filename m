From: "Hommel, Thomas (GE Indust, GE Fanuc)" <Thomas.Hommel@gefanuc.com>
Subject: RE: Mptlinux crashes on kernel 2.6.22.1
Date: Tue, 7 Aug 2007 12:58:04 +0200
Message-ID: <62DDBB9E5E23CC4A929EE46F9427CEAF1F8475@BUDMLVEM04.e2k.ad.ge.com>
References: <62DDBB9E5E23CC4A929EE46F9427CEAF1F8007@BUDMLVEM04.e2k.ad.ge.com> <62DDBB9E5E23CC4A929EE46F9427CEAF1F829D@BUDMLVEM04.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-nj2ut-11.online-age.net ([64.14.54.241]:58416 "EHLO
	ext-nj2ut-11.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758151AbXHGK6K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 06:58:10 -0400
Received: from int-nj2ut-2.online-age.net (int-nj2ut-2.online-age.net [3.159.237.71])
	by ext-nj2ut-11.online-age.net (8.13.6/8.13.6/20051114-SVVS-TLS-DNSBL) with ESMTP id l77Aw8hf001490
	for <linux-scsi@vger.kernel.org>; Tue, 7 Aug 2007 06:58:08 -0400
Received: from cinmlef12.e2k.ad.ge.com (int-nj2ut-2.online-age.net [3.159.237.71])
	by int-nj2ut-2.online-age.net (8.13.6/8.13.6/20050510-SVVS) with ESMTP id l77Aw7JI004616
	for <linux-scsi@vger.kernel.org>; Tue, 7 Aug 2007 06:58:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <62DDBB9E5E23CC4A929EE46F9427CEAF1F829D@BUDMLVEM04.e2k.ad.ge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, eric.moore@lsi.com

Here's a record of driver initialization with debugging enabled. I can't
figure out what goes wrong, but maybe sombody else can...

Any help is appreciated

Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
mptbase: Register for IOC reset notification
Fusion MPT SPI Host driver 3.04.04
mptspi: Registered for IOC event notifications
mptspi: Registered for IOC reset notifications
mptbase: mpt_adapter_install
mptbase: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED
mptbase: Using 64 bit consistent mask
mptbase: mem = c1080000, mem_phys = 80000000
mptbase: facts @ afe3b274, pfacts[0] @ afe3b2c4
mptbase: ioc0: PCI device 0000:02:04.0 devfn=2/20, searching for devfn
match on ffffffff or 1
mptbase: Initiating ioc0 bringup
mptbase::MakeIocReady, ioc0 [raw] state=10000000
mptbase: ioc0: Sending get IocFacts request req_sz=12 reply_sz=80
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: Handshake request frame (@bffc3d48) header
  03000000 00000000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=0
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=030f0102
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  030f0102 00000e00 00000000 00000000 00000000 00080030 001800ff
02020000 00000000 000100ff 00000000 01100000 00009f30 01940192 01032700
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=15)
mptbase: ioc0: HandShake reply count=15
mptbase: ioc0: NB_for_64_byte_frame=2 NBShiftFactor=5 BlockSize=8
mptbase: ioc0: reply_sz= 80, reply_depth= 128
mptbase: ioc0: req_sz  = 96, req_depth  = 255
mptbase: ioc0: Sending get PortFacts(0) request
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: Handshake request frame (@bffc3d54) header
  05000000 00000000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=0
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=050a0000
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  050a0000 00000000 00000000 00000000 00000000 00100100 000c0007
00000020 00000000 00000000
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=10)
mptbase: ioc0: HandShake reply count=10
ioc0: 53C1030: Capabilities={Initiator,Target}
mptbase: ioc0 installed at interrupt 16
mptbase: ioc0 ReqToChain alloc  @ afe35000, sz=1020 bytes
mptbase: ioc0 RequestNB alloc  @ afe41c00, sz=1020 bytes
mptbase: ioc0 num_sge=17 numSGE=534
mptbase: ioc0 Now numSGE=128 num_sge=138 num_chain=13
mptbase: ioc0 ChainToChain alloc @ a0830000, sz=6604 bytes
mptbase: ioc0.ReplyBuffer sz=80 bytes, ReplyDepth=128
mptbase: ioc0.ReplyBuffer sz=10240[2800] bytes
mptbase: ioc0.RequestBuffer sz=96 bytes, RequestDepth=255
mptbase: ioc0.RequestBuffer sz=24480[5fa0] bytes
mptbase: ioc0.ChainBuffer sz=96 bytes, ChainDepth=1651
mptbase: ioc0.ChainBuffer sz=158496[26b20] bytes num_chain=1651
mptbase: ioc0.Total alloc @ bfe80000[1fe80000], sz=193216[2f2c0] bytes
mptbase: ioc0 ReplyBuffers @ bfe80000[1fe80000]
mptbase: ioc0 RequestBuffers @ bfe82800[1fe82800]
mptbase :ioc0 ChainBuffers @ bfe887a0(1fe887a0)
mptbase: ioc0.SenseBuffers @ afe7c000[0fe7c000]
mptbase: ioc0.ReplyBuffers @ bfe80000[1fe80000]
mptbase: ioc0: upload_fw 0 facts.Flags=0
mptbase: ioc0: facts.MsgVersion=102
mptbase: ioc0: Sending IOCInit (req @ bffc3d2c)
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=44, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: Handshake request frame (@bffc3d2c) header
  02000004 00011000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=0
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=10
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=02050004
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  02050004 00011000 00000000 00000000 00000000
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=5)
mptbase: ioc0: HandShake reply count=5
mptbase: ioc0: Sending PortEnable (req @ bffc3d2c)
mptbase: ioc0: Sending Port(0)Enable (req @ bffc3cf8)
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: Handshake request frame (@bffc3cf8) header
  06000000 00000000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=0
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=30
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=06050000
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  06050000 00000000 00000000 00000000 00000000
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=5)
mptbase: ioc0: HandShake reply count=5
mptbase: ioc0: INFO - Wait IOC_OPERATIONAL state (cnt=0)
mptbase: ioc0: Sending EventNotification (1) request bfe82800
mptbase: ioc0: mf_dma_addr=1fe82802 req_idx=0 RequestNB=2
mptbase: ioc0: SCSI device NVRAM settings @ a08bb9a0, sz=64
mptbase: ioc0: Sending Config request type 3, page 0 and action 0
mptbase: ioc0: mf_dma_addr=1fe82862 req_idx=1 RequestNB=2
mptbase: ioc0: WARNING - mpt_timer_expired!
mptbase: IOC setup_reset routed to MPT base driver!
mptbase: Initiating ioc0 recovery
mptbase::MakeIocReady, ioc0 [raw] state=24000000
mptbase: ioc0: IOC operational unexpected
mptbase: whoinit 0x4 statefault 0 force 1
mptbase: KickStarting ioc0!
mptbase: ioc0: Sending IOC reset(0x40)!
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: DbG1: diag0=00000120, diag1=00000000
mptbase: ioc0: Wrote magic DiagWriteEn sequence (1a0)
mptbase: ioc0: DbG2: diag0=000001a0, diag1=00000000
mptbase: ioc0: Diagnostic reset performed
mptbase: ioc0: Calling IOC pre_reset handler #15
mptbase: IOC pre_reset routed to MPT base driver!
mptbase: ioc0: Calling IOC pre_reset handler #14
mptbase: ioc0: DbG3: diag0=00000120, diag1=00000000
mptbase: ioc0: DbG4: diag0=00000100, diag1=00000000
mptbase: ioc0: Diagnostic reset successful!
mptbase: ioc0: KickStart successful! (cnt=0)
mptbase: ioc0: Sending get IocFacts request req_sz=12 reply_sz=80
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: Handshake request frame (@a0373cb8) header
  03000000 00000000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=0
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=030f0102
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  030f0102 00000e00 00000000 00000000 00000000 00080030 001800ff
02020000 00000000 000100ff 00000000 01100000 00009f30 01940192 01032700
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=15)
mptbase: ioc0: HandShake reply count=15
mptbase: ioc0: NB_for_64_byte_frame=2 NBShiftFactor=5 BlockSize=8
mptbase: ioc0.ReplyBuffers @ bfe80000[1fe80000]
mptbase: ioc0: upload_fw 0 facts.Flags=0
mptbase: ioc0: facts.MsgVersion=102
mptbase: ioc0: Sending IOCInit (req @ a0373c9c)
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=44, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: Handshake request frame (@a0373c9c) header
  02000004 00011000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=0
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=10
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=02050004
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  02050004 00011000 00000000 00000000 00000000
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=5)
mptbase: ioc0: HandShake reply count=5
mptbase: ioc0: Sending PortEnable (req @ a0373c9c)
mptbase: ioc0: Sending Port(0)Enable (req @ a0373c68)
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: Handshake request frame (@a0373c68) header
  06000000 00000000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=0
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=30
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=06050000
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  06050000 00000000 00000000 00000000 00000000
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=5)
mptbase: ioc0: HandShake reply count=5
mptbase: ioc0: INFO - Wait IOC_OPERATIONAL state (cnt=0)
mptbase: ioc0: Sending EventNotification (1) request bfe828c0
mptbase: ioc0: mf_dma_addr=1fe828c2 req_idx=2 RequestNB=2
mptbase: ioc0: Calling IOC post_reset handler #15
mptbase: IOC post_reset routed to MPT base driver!
mptbase: ioc0: Calling IOC post_reset handler #14
mptbase: ioc0: WARNING - mpt_timer_expired complete!
Unable to handle kernel paging request for data at address 0x00000542
Faulting instruction address: 0xa01d93b8
Oops: Kernel access of bad area, sig: 11 [#1]
SBS CM6
NIP: a01d93b8 LR: a01d93b8 CTR: a000c2ac
REGS: bffcbea0 TRAP: 0300   Not tainted  (2.6.22.1)
MSR: 00009032 <EE,ME,IR,DR>  CR: 82004028  XER: 00000000
DAR: 00000542, DSISR: 40000000
TASK = bffc0030[5] 'events/0' THREAD: bffca000
GPR00: a01d93b8 bffcbf50 bffc0030 bfffd0c0 bfff7800 00000001 004971e0
00000000
GPR08: 0001c7d0 00000010 a039c000 bfff783c 00000000 ff9f6b57 0fffbd00
ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 007ffeb0 00000000
a034dd74
GPR24: a0350000 a034dd74 a0030000 a034dd74 a02e0000 bffca000 a01d93a0
000002c4
NIP [a01d93b8] mptspi_dv_renegotiate_work+0x18/0x120
LR [a01d93b8] mptspi_dv_renegotiate_work+0x18/0x120
Call Trace:
[bffcbf50] [a01d93b8] mptspi_dv_renegotiate_work+0x18/0x120 (unreliable)
[bffcbf80] [a002d33c] run_workqueue+0xac/0x158
[bffcbfa0] [a002d7a8] worker_thread+0x6c/0xd0
[bffcbfd0] [a0030e74] kthread+0x84/0x8c
[bffcbff0] [a00115c4] kernel_thread+0x44/0x60
Instruction dump:
4bffd6d1 80010024 83e1001c 38210020 7c0803a6 4e800020 7c0802a6 9421ffd0
bf810020 90010034 83e30010 4be83521 <a01f027e> 2f800000 419e009c
813f0000
mptbase: ioc0: Sending Config request type 4, page 1 and action 0
mptbase: ioc0: mf_dma_addr=1fe82922 req_idx=3 RequestNB=2
mptbase: ioc0: WARNING - mpt_timer_expired!
mptbase: IOC setup_reset routed to MPT base driver!
mptbase: Initiating ioc0 recovery
mptbase::MakeIocReady, ioc0 [raw] state=24000000
mptbase: ioc0: IOC operational unexpected
mptbase: whoinit 0x4 statefault 0 force 1
