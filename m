From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Persistent Reservation
Date: Thu, 16 Nov 2006 12:52:46 -0500
Message-ID: <455CA56E.202@torque.net>
References: <216D6FA68B0F304DA93E95C5B786F2D17C8439@bart.corp.egenera.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:30888 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1031162AbWKPRww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 12:52:52 -0500
In-Reply-To: <216D6FA68B0F304DA93E95C5B786F2D17C8439@bart.corp.egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jansen, Frank" <fjansen@egenera.com>
Cc: djshetty <dhirajshetty.junk@mailnull.com>, linux-scsi@vger.kernel.org

Jansen, Frank wrote:
> Dhiraj,
> 
> In the most common case, persistent reservations are stored with the
> device, such as the storage array.  Note that not all devices
> implement/support persistent reservations and there are cases where the
> reservations are stored elsewhere, which tends to be the approach in
> virtualizing environments.

The linux SCSI subsystem doesn't interact with lu
persistent reservations. Last time I looked, the
kernel was pretty noisy when a RESERVATION CONFLICT
status was received, even via a sg device node.

You can manipulate persistent reservations from the
user space with sg_persist in sg3_utils package.

Device support for persistent reservations is improving,
Fujitsu SCSI disks have had it for some time. I
noticed that the Seagate 15K.5 series support those
commands while the 15K.4 series and earlier didn't.

Doug Gilbert

>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org 
>> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of djshetty
>> Sent: Thursday, November 16, 2006 7:27 AM
>> To: linux-scsi@vger.kernel.org
>> Subject: Persistent Reservation
>>
>>
>> Hi,
>>
>> I had a doubt. In order to persist the reservation we need to 
>> store some information like reservation keys, scope, type of 
>> reservation etc.
>>
>> Where exactly are such information stored and by whom ?
>>
>> Regards,
>> Dhiraj
>> --
>> View this message in context: 
>> http://www.nabble.com/Persistent-Reservation-tf2642680.html#a7376789
>> Sent from the linux-scsi mailing list archive at Nabble.com.
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-scsi" in the body of a message to 
>> majordomo@vger.kernel.org More majordomo info at  
>> http://vger.kernel.org/majordomo-info.html
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

