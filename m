From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.37: USB Thermaltake Dock: Only see's 1 HDD? [SOLVED, but
 which option fixed it?]
Date: Fri, 18 Feb 2011 16:45:47 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1102181645400.5553@p34.internal.lan>
References: <alpine.DEB.2.02.1102181621190.4561@p34.internal.lan> <1298065469.3007.193.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1298065469.3007.193.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org



On Fri, 18 Feb 2011, James Bottomley wrote:

> On Fri, 2011-02-18 at 16:33 -0500, Justin Piszcz wrote:
>> When I attach a dock with two HDD's on it in Linux, it only picks up one HDD,
>> this is with a Thermaltake BlackX Duet, is there a special module/etc
>> I need to load so it sees both drives on USB?
>>
>> So I added some additional kernel options and now it seems fixed, but
>> this is more of a shotgun approach, instead of rebuilding/rebooting
>> several times does anyone know which module enabled support of > 1 HDD on
>> the USB dock as shown below?
> [...]
>> Now:
>>
>> [    4.176148] scsi 12:0:0:0: Direct-Access     ST310003 40AS                  PQ: 0 ANSI: 2 CCS
>> [    4.176370] sd 12:0:0:0: Attached scsi generic sg2 type 0
>> [    4.176893] scsi 12:0:0:1: Direct-Access     ST310003 40AS                  PQ: 0 ANSI: 2 CCS
>> [    4.177063] sd 12:0:0:1: Attached scsi generic sg3 type 0
>
> Well that's showing as one disc with multiple LUNs , so
> CONFIG_SCSI_MULTI_LUN=y
>
> James
>
>

Thanks!

Justin.
