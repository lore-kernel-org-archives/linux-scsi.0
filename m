From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Linux version 2.6.6 // libata 1.02 // sata_promise version 0.92
 // problem with Promise FastTrack S150 SX4
Date: Wed, 19 May 2004 18:32:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40ABE09A.10802@pobox.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAA6/QqhRnc20Gp8M2IBiikcMKAAAAQAAAAoC6hppJpiEatjNFHGy82SgEAAAAA@nawan.hostinguk.com> <40A8FF29.7090701@pobox.com> <20040519185302.GE5547@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:62165 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264660AbUESWdL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 18:33:11 -0400
In-Reply-To: <20040519185302.GE5547@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

Kurt Garloff wrote:
> On Mon, May 17, 2004 at 02:06:33PM -0400, Jeff Garzik wrote:
> 
>>This is normal.
>>
>>Promise proprietary RAID is not supported under Linux, by the kernel 
>>drivers.
> 
> 
> They should publish the metadata format of their fakeRAID stuff.
> Somebody could parse this and setup linux SW raid accordingly
> from userspace.


Promise did, and somebody did.  :)  But not in the kernel.

See Carl-Denial Hailfinger's "raiddetect" work...

	Jeff



