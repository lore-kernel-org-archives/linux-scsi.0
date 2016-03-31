From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] uas: Add a new NO_REPORT_LUNS quirk
Date: Thu, 31 Mar 2016 07:48:02 -0700
Message-ID: <1459435682.2958.19.camel@HansenPartnership.com>
References: <1459426971-11927-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54948 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530AbcCaOsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 10:48:05 -0400
In-Reply-To: <1459426971-11927-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>
Cc: David Webb <djw@noc.ac.uk>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Thu, 2016-03-31 at 14:22 +0200, Hans de Goede wrote:
> Add a new NO_REPORT_LUNS quirk and set it for Seagate drives with
> an usb-id of: 0bc2:331a, as these will fail to respond to a
> REPORT_LUNS command.

Actually, if we're sending them a report luns command, they must be
reporting in at SCSI-3 SPC or higher.  Should we be quirking them down
to SCSI-2 instead because it reduces the risk of running into something
else they're not doing from the SPC command set?

James


