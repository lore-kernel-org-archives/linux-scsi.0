From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH fix for 3.17] uas: Add a quirk for rejecting ATA_12 and
 ATA_16 commands
Date: Mon, 15 Sep 2014 15:21:56 +0200
Message-ID: <5416E7F4.7040604@redhat.com>
References: <1410603548-3579-2-git-send-email-hdegoede@redhat.com> <Pine.LNX.4.44L0.1409131009530.7476-100000@netrider.rowland.org> <063D6719AE5E284EB5DD2968C1650D6D17491F5F@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17491F5F@AcuExch.aculab.com>
Sender: stable-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>, 'Alan Stern' <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09/15/2014 10:42 AM, David Laight wrote:
> From: Alan Stern
> ...
>>>  	p = quirks;
>>>  	while (*p) {
>>> @@ -543,6 +544,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
>>>  		case 's':
>>>  			f |= US_FL_SINGLE_LUN;
>>>  			break;
>>> +		case 't':
>>> +			f |= US_FL_NO_ATA_1X;
>>> +			break;
>>>  		case 'u':
>>>  			f |= US_FL_IGNORE_UAS;
>>>  			break;
>>
>> You must not add an aditional value for a module parameter without
>> documenting it in Documentation/kernel-parameters.txt.
> 
> How can this work as a 'module parameter'?
> I might want to use two different usb-scsi devices that have different
> requirements.

The usb-storage.quirks format includes a usb prod:vend if pair, so unless
you've 2 identical devices, you can specify which quirks to apply to
which device.

Regards,

Hans
