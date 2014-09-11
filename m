From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uas: Add missing le16_to_cpu calls to asm1051 / asm1053
 usb-id check
Date: Thu, 11 Sep 2014 14:21:21 -0700
Message-ID: <20140911212121.GA1472@kroah.com>
References: <1410426372-10151-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaIKVVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 17:21:22 -0400
Content-Disposition: inline
In-Reply-To: <1410426372-10151-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Thu, Sep 11, 2014 at 11:06:12AM +0200, Hans de Goede wrote:
> Cc: stable@vger.kernel.org # 3.16
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/usb/storage/uas-detect.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

You forgot the reported-by line, I'll go add it...
