From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/12] mptfusion : Description patch
Date: Thu, 18 Mar 2010 19:09:03 +0530
Message-ID: <20100318133852.GA22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:50336 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891Ab0CROKL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:10:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

MPT Fusion driver updates. Please consider it for next rc update.
I have taken patches against 2.6.34-rc1.

[PATCH 01/12] mptfusion: Added new less expensive RESET (Message Unit Reset)
[PATCH 02/12] mptfusion: Updated SCSI IO IOCTL error handling.
[PATCH 03/12] mptfusion: mpt config will do Hard Reset based upon retry counts
[PATCH 04/12] mptfusion: mpt_detach is called properly at the time of
remove.
[PATCH 05/12] mptfusion: Proper bus_type check is added.
[PATCH 06/12] mptfusion: Setting period,offset and width for SPI driver
[PATCH 07/12] mptfusion: sanity check vdevice check is added
[PATCH 08/12] mptfusion: Task abort is not supported for Volumes 
[PATCH 09/12] mptfusion: Check for command status is added after completion. 
[PATCH 10/12] mptfusion: Event data alignment with 4 byte. 
[PATCH 11/12] mptfusion: Proper error handling is added after mpt_config
timeout. 
[PATCH 12/12] mptfusion: Bump version 03.04.15

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
