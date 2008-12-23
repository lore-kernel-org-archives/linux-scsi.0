From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Tue, 23 Dec 2008 13:31:21 +0100
Message-ID: <200812231331.22204.oliver@neukum.org>
References: <20081223073049.D4AB3108040@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:50305 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLWMcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Dec 2008 07:32:18 -0500
In-Reply-To: <20081223073049.D4AB3108040@picon.linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

Am Dienstag, 23. Dezember 2008 08:30:49 schrieb bugme-daemon@bugzilla.kernel.org:
> http://bugzilla.kernel.org/show_bug.cgi?id=12207
> 
> 
> kai.makisara@kolumbus.fi changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |kai.makisara@kolumbus.fi
> 
> 
> 
> 
> ------- Comment #3 from kai.makisara@kolumbus.fi  2008-12-22 23:30 -------
> I have been testing large blocks with 2.6.27.7 and I was able to reach 6 MB
> without any tricks. The difference between your system and mine is that my tape
> is connected with SCSI and yours is with USB.
> 
> Looking at linux/drivers/usb/storage/scsiglue,c I find the following:
> 
>         /* limit the total size of a transfer to 120 KB */
>         .max_sectors =                  240,
> 
> Maybe the USB experts can tell what is the reason for this.

Many USB devices fail larger transfers.

	Regards
		Oliver


