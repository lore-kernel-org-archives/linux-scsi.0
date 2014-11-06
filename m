From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: Large disk drives
Date: Thu, 06 Nov 2014 18:43:27 +0200
Message-ID: <545BA52F.6050205@gmail.com>
References: <Pine.LNX.4.44L0.1411061049310.886-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50066 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaKFQnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 11:43:31 -0500
In-Reply-To: <Pine.LNX.4.44L0.1411061049310.886-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <boaz@plexistor.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, "Dale R. Worley" <worley@alum.mit.edu>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On 11/06/2014 05:53 PM, Alan Stern wrote:
>> But just the simple case of read-capacity failure should we then?
> 
> That's a separate question.  As far as I know, the case you are 
> describing has not come up.
> 

BTW: what we should do is when the partition parser at the block layer
see that the partition capacity as written in the partition-table is
bigger then the capacity reported for the device we can put a fat
message at dmesg with both sizes and user can decide.
And/or add an extra field at block attributes for part_capacity. It
is info that is known and parsed for today.

> Alan Stern

Thanks
Boaz

