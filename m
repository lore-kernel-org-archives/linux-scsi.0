From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Suggested patch for testing last sector of USB devices
Date: Sun, 21 Dec 2008 21:24:35 +0100
Message-ID: <494EA603.7080105@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0812192009210.16918-100000@netrider.rowland.org> <494E8531.3000205@s5r6.in-berlin.de> <200812211925.27140.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56445 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYLUUfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Dec 2008 15:35:17 -0500
In-Reply-To: <200812211925.27140.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Oliver Neukum wrote:
> Am Sonntag, 21. Dezember 2008 19:04:33 schrieb Stefan Richter:
>> Alan Stern wrote:
>>> --- usb-2.6.orig/include/scsi/scsi_device.h
>>> +++ usb-2.6/include/scsi/scsi_device.h
>>> @@ -142,6 +142,7 @@ struct scsi_device {
>>>       unsigned select_no_atn:1;
>>>       unsigned fix_capacity:1;        /* READ_CAPACITY is too high by 1 */
>>>       unsigned guess_capacity:1;      /* READ_CAPACITY might be too high by 1 */
>>> +     unsigned check_capacity:1;      /* Verify READ_CAPACITY result */
>> Maybe add "ignored if no USB_STORAGE support is built" to the comment
>> since it is a no-op otherwise:
> 
> Are there really no firewire devices with the same problem?

So far only Apple iPods with FireWire + USB combo interface have become
known to feature this bug.
-- 
Stefan Richter
-=====-==--- ==-- =-=-=
http://arcgraph.de/sr/
