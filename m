From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Tue, 04 Mar 2008 01:37:03 +0100
Message-ID: <47CC99AF.10509@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0803031758310.8280-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42368 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYCDAhL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 19:37:11 -0500
In-Reply-To: <Pine.LNX.4.44L0.0803031758310.8280-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

>> On Mon, 2008-03-03 at 15:16 -0500, Alan Stern wrote:
>>> This count
>>> will be used by usb-storage to determine whether USB-PERSIST should be
>>> forced on during a suspend.

Why should devices without openers be treated differently from devices 
with openers?
-- 
Stefan Richter
-=====-==--- --== --=--
http://arcgraph.de/sr/
