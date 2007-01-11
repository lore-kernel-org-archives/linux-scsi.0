From: "Thayne Harmon" <THARMON@novell.com>
Subject: no utility / method to show association between host bus
	adapter and non-sg BLOCK devices
Date: Thu, 11 Jan 2007 12:23:15 -0700
Message-ID: <45A62C32.8E7F.00B8.0@novell.com>
References: <8260533.post@talk.nabble.com> <45A53290.1060400@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sinclair.provo.novell.com ([137.65.248.137]:50940 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXAKTne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 14:43:34 -0500
In-Reply-To: <45A53290.1060400@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Gentlemen,

hwinfo, lshal, sysfs do not show the relationship for non-sg BLOCK devices with there 
associated Host Bus Adapter.

Do you know of a utility or method that can show this?

Example is the HP/Compaq CCISS block driver.

The HBA and devices are listed, but no association is given or can be determine, 
only by the user knowing which is which.

The kernel certainly knows, surely the above apps could be made to 
determine this or some utility exits that will show this?

Thanks for any help,

Thayne Harmon

