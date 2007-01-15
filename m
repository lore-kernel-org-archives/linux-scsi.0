From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Mon, 15 Jan 2007 12:50:40 -0800
Message-ID: <45ABE920.7090304@us.ibm.com>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net> <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no> <45A69937.8030400@us.ibm.com> <45A6C33C.8060900@scanventure.no> <45A81BBF.7050104@us.ibm.com> <45AA4A7B.7070607@scanventure.no>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:35961 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbXAOUuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2007 15:50:46 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0FKoghQ020736
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2007 15:50:42 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0FKogS4488436
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2007 13:50:42 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0FKof8I013323
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2007 13:50:41 -0700
In-Reply-To: <45AA4A7B.7070607@scanventure.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tarjei@nu.no
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, "Chim, Ed" <ed_chim@adaptec.com>, Alexis Bruemmer <alexisb@us.ibm.com>

Tarjei Huse wrote:

> Duh! Thanks :-)
> 
> After doing as you suggested, and running make oldconfig using the
> configuration from Ubuntu Dapper (2.6.15-23-server) and the stock Ubuntu
> Edgy I get the same error when booting the kernel:
> 
> PCI: BIOS Bug: MCFG area at e00000000 is not E820-reserved
> PCI: Not using MMCONFIG
> PCI Cannot allocate resource region 7 of bridge 0000:00:01.1
> PCI Cannot allocate resource region 8 of bridge 0000:00:01.1
> PCI Cannot allocate resource region 9 of bridge 0000:00:01.1

This is a known conflict between the kernel and the BIOS.  As far as I
know this should not affect the operation of the aic94xx because it is a
PCIX device, and bridge 0:0:1.1 is a PCIe port.  At least on the x306m...

> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown
> wn-block(0,0)
> 
> Is this some missing compile option or a bug?

Perhaps.  Could you send a full output?  It does not appear that the
aic94xx driver is loading at all...?

--D
