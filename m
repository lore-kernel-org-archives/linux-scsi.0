From: Roessner Christian <info@roessner-net.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Thu, 15 Apr 2004 18:11:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404151811.21578.info@roessner-net.com>
References: <Pine.LNX.4.44.0404132232490.11576-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:17883 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S264327AbUDOQLF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 12:11:05 -0400
In-Reply-To: <Pine.LNX.4.44.0404132232490.11576-100000@poirot.grange>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org

Sorry, forgot to send /proc-stuff:

/proc/scsi/scsi:

Host: scsi1 Channel: 00 Id: 04 Lun: 00
  Vendor: TEAC     Model: CD-W512SB        Rev: 1.0B
  Type:   CD-ROM                           ANSI SCSI revision: 02


/proc/scsi/tmscsim/1:

Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.1b 2004-04-13
SCSI Host Nr 1, AM53C974 Adapter Nr 0
IOPortBase 0x9400, IRQ 11
MaxID 7, MaxLUN 1, AdapterID 7, SelTimeout 250 ms, DelayReset 1 s
TagMaxNum 16, Status 0x00, ACBFlag 0x00, GlitchEater 24 ns
Statistics: Cmnds 91786, Cmnds not sent directly 76000, Out of SRB conds 0
            Lost arbitrations 0, Sel. connected 0, Connected: No
Nr of attached devices: 1, Nr of DCBs: 1
Map of attached LUNs: 00 00 00 00 01 00 00 00
Idx ID LUN Prty Sync DsCn SndS TagQ NegoPeriod SyncSpeed SyncOffs MaxCmd
00  04  00  Yes  Yes  Yes  Yes  No    200 ns     5.0 M      08      01
Commands in Queues: Query: 0:


Regards

Christian
