From: "Massey, James" <James.Massey@goodrich.com>
Subject: scsi target emulation
Date: Mon, 10 Mar 2008 18:12:56 -0000
Message-ID: <45D1B79D2DCCF34E966D24728765DDB378C265@nhc2ex11.goodrich.root.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lts-mxgateway.goodrich.com ([12.129.98.97]:36110 "EHLO
	lts-mxgateway.goodrich.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbYCJSmQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 14:42:16 -0400
Received: from GR-GWI-EAST-A.goodrich.com (gr-gwi-east-a.goodrich.com [170.126.120.4])
	by lts-mxgateway.goodrich.com (Symantec Mail Security) with ESMTP id 9A26D4DC002
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2008 14:13:01 -0400 (EDT)
Received: from nhc1ex01.goodrich.root.local (localhost [127.0.0.1])
	by GR-GWI-EAST-A.goodrich.com (8.13.5/8.13.5) with ESMTP id m2AICvej025036
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2008 14:13:01 -0400 (EDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am trying to setup a system which has a SCSI initiator and a SCSI
target:

Two PCs running Linux. Each PC has a fibre channel HBA. The two HBAs are
directly connected to each other (no switch in-between). One PC acts as
the SCSI initiator and the other a SCSI target.

Previously, I have used a Linux PC, the sg device driver and utilities
to read data from a disk with a fibre channel interface. In this setup
the sg driver was acting as a SCSI initiator and this works ok.

Now I wish to setup a PC running Linux to act as a SCSI target. The HBA
claims to have SCSI target support. I am unsure of how to access the
data (e.g. from on a write call made by the SCSI initiator) via a user
space application. Can I use the sg driver to do this or do I need to
use SCST in user mode?

James Massey 
--------------------------------------------------------

Rosemount Aerospace Limited.
Registered Office: Stratford Road, Solihull, West Midlands, B90 4LA.
Registered in England No. 02849033.

--------------------------------------------------------
