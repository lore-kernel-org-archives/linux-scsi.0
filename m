From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 00/08] mptfusion : Description patch
Date: Thu, 17 Jun 2010 14:35:00 +0530
Message-ID: <20100617090452.GA29165@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:58631 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233Ab0FQJkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 05:40:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT Fusion driver updates. Please consider it for next rc update.
I have taken patches against 2.6.35-rc2

[PATCH 01/08] mptfusion: Set fw_events_off to 1 at driver load time.
[PATCH 02/08] mptfusion: Use DID_TRANSPORT_DISRUPTED instead of
DID_BUS_BUSY.
[PATCH 03/08] mptfusion: Corrected declaration of device_missing_delay
[PATCH 04/08] mptfusion: Added sanity to check B_T mapping for device before
adding to OS
[PATCH 05/08] mptfusion: schedule_target_reset from all Reset context
[PATCH 06/08] mptfusion: Added code for occationally SATA hotplug failure.
[PATCH 07/08] mptfusion: Added missing reset for ioc_reset_in_progress in
SoftReset
[PATCH 08/08] mptfusion: Bump version 03.04.16

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
