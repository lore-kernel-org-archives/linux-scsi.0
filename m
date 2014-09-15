From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH fix for 3.17 v5] uas: Add a quirk for rejecting ATA_12
 and ATA_16 commands
Date: Mon, 15 Sep 2014 07:08:07 -0700
Message-ID: <20140915140807.GA26412@kroah.com>
References: <1410789852-30567-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaIOOI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Sep 2014 10:08:57 -0400
Content-Disposition: inline
In-Reply-To: <1410789852-30567-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Mon, Sep 15, 2014 at 04:04:12PM +0200, Hans de Goede wrote:
> And set this quirk for the Seagate Expansion Desk (0bc2:2312), as that one
> seems to hang upon receiving an ATA_12 or ATA_16 command.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=79511
> https://bbs.archlinux.org/viewtopic.php?id=183190
> 
> While at it also add missing documentation for the u value for usb-storage
> quirks.
> 
> Cc: stable@vger.kernel.org # 3.16
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> --
> Changes in v2: Add documentation for new t and u usb-storage.quirks flags
> Changes in v3: Fix typo in documentation
> Changes in v4: Also apply the quirk to (0bc2:3312)
> Changes in v5: Rebased on 3.17-rc5, drop u documentation, already upstream

So I should wait another day for v6?  :)

greg k-h
