From: Alan Stern <stern@rowland.harvard.edu>
Subject: SCSI layer retries even when medium is not present
Date: Fri, 21 Mar 2003 10:08:02 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0303211004050.806-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

Can anybody explain why the SCSI layer issues READ-CAPACITY three times in
a row (for an emulated direct-access drive) when each time the sense code
indicates the medium is not present?

Wouldn't just once be enough?

Alan Stern



