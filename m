From: dan.j.williams@intel.com
Subject: [PATCH RFC 0/2] imu-scsi for iop13xx
Date: Wed, 24 Jan 2007 11:22:45 -0700
Message-ID: <20070124182245.6029.43097.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37703 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbXAXSYk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jan 2007 13:24:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@arm.linux.org.uk, James.Bottomley@steeleye.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-scsi@vger.kernel.org, dan.j.williams@intel.com, greg.b.tucker@intel.com

The imu (inter-processor messaging unit) on the iop13xx enables mailbox
style communication between the two cores on iop13xx.  Greg Tucker has
has wrapped this capability in a scsi driver which allows Linux to
interface with the other core as if it were a scsi disk target.  I would
like to submit it for 2.6.21 consideration.  As it is an
ARM-platform-specific driver does it fall under Russell's purview, or
James' since it is a scsi driver.

Regards,
Dan

Greg Tucker (2):
      iop13xx: add base support for the imu
      iop13xx: imu scsi driver

[note: linux-arm-kernel@lists.arm.linux.org.uk is subscriber-only ]
