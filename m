From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Wed, 15 Nov 2017 10:32:49 +0100
Message-ID: <17656fe5-ec4e-36d7-12d3-07442c918974@redhat.com>
References: <Pine.LNX.4.44L0.1711141022580.1796-100000@iolanthe.rowland.org>
 <c03f33ff-81e8-1753-f648-94c107e994ad@redhat.com>
 <1510736818.5412.2.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1510736818.5412.2.camel@suse.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 15-11-17 10:06, Oliver Neukum wrote:
> Am Dienstag, den 14.11.2017, 18:44 +0100 schrieb Hans de Goede:
>>
>> Greg, please do no merge the 2 recent uas seagate quirks I send
>> then. I will submit a patch with the new approach right away.
> 
> Hi,
> 
> I am afraid in that case we will need a way to override a
> quirk in the other direction, that is, to not apply it.

We already have that usb_stor_adjust_quirks when a match to the
device's vend:prod ids is found in usb_storage.quirks,
usb_stor_adjust_quirks will clear all quirks it allows to be set
through the usb_storage.quirks module option.

Regards,

Hans
