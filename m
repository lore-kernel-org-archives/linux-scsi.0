From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH fix for 3.17 v5] uas: Add a quirk for rejecting ATA_12
 and ATA_16 commands
Date: Mon, 15 Sep 2014 16:13:52 +0200
Message-ID: <5416F420.9080901@redhat.com>
References: <1410789852-30567-1-git-send-email-hdegoede@redhat.com> <20140915140807.GA26412@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbaIOON7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2014 10:13:59 -0400
In-Reply-To: <20140915140807.GA26412@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hi,

On 09/15/2014 04:08 PM, Greg Kroah-Hartman wrote:
> On Mon, Sep 15, 2014 at 04:04:12PM +0200, Hans de Goede wrote:
>> And set this quirk for the Seagate Expansion Desk (0bc2:2312), as that one
>> seems to hang upon receiving an ATA_12 or ATA_16 command.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=79511
>> https://bbs.archlinux.org/viewtopic.php?id=183190
>>
>> While at it also add missing documentation for the u value for usb-storage
>> quirks.
>>
>> Cc: stable@vger.kernel.org # 3.16
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> --
>> Changes in v2: Add documentation for new t and u usb-storage.quirks flags
>> Changes in v3: Fix typo in documentation
>> Changes in v4: Also apply the quirk to (0bc2:3312)
>> Changes in v5: Rebased on 3.17-rc5, drop u documentation, already upstream
> 
> So I should wait another day for v6?  :)

Hehe, no I certainly hope not.

Chances are I there will eventually be more seagate models needing the quirk,
but I've none in the pipeline atm, and we can always add those with an
incremental patch.

So if this is not too late for 3.17 and you can pick up v5 that would be great.

Thanks,

Hans
