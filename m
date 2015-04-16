From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/3] uas: Add US_FL_MAX_SECTORS_240 flag
Date: Thu, 16 Apr 2015 10:19:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1504161018500.1391-100000@iolanthe.rowland.org>
References: <1429186634-6184-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41867 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753985AbbDPOTg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 10:19:36 -0400
In-Reply-To: <1429186634-6184-2-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steve Bangert <sbangert@frontier.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 16 Apr 2015, Hans de Goede wrote:

> The usb-storage driver sets max_sectors = 240 in its scsi-host template, for
> uas we do not want to do that for all devices, but testing has shown that
> some devices need it.
> 
> This commit adds a US_FL_MAX_SECTORS_240 flag for such devices, and implements
> support for it in uas.c, while at it it also adds support for
> US_FL_MAX_SECTORS_64 to uas.c.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

You forgot to update Documentation/kernel-parameters.txt.

Alan Stern

