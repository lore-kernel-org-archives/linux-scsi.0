From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Wed, 15 Nov 2017 10:06:58 +0100
Message-ID: <1510736818.5412.2.camel@suse.com>
References: <Pine.LNX.4.44L0.1711141022580.1796-100000@iolanthe.rowland.org>
         <c03f33ff-81e8-1753-f648-94c107e994ad@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <c03f33ff-81e8-1753-f648-94c107e994ad@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, den 14.11.2017, 18:44 +0100 schrieb Hans de Goede:
> 
> Greg, please do no merge the 2 recent uas seagate quirks I send
> then. I will submit a patch with the new approach right away.

Hi,

I am afraid in that case we will need a way to override a
quirk in the other direction, that is, to not apply it.

	Regards
		Oliver
 
