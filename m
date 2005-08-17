From: Marko Macek <Marko.Macek@gmx.net>
Subject: Re: oops when removing storage device with no actual drive
Date: Wed, 17 Aug 2005 19:22:04 +0200
Message-ID: <4303723C.3080903@gmx.net>
References: <43023C86.8050705@gmx.net> <1124281453.5038.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53438 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750722AbVHQRXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2005 13:23:22 -0400
In-Reply-To: <1124281453.5038.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:

>On Tue, 2005-08-16 at 21:20 +0200, Marko Macek wrote:
>  
>
>>EIP is at sysfs_hash_and_remove+0x13/0xeb
>>    
>>
>This is suspiciously similar to the oops when trying to add new class
>links in the devices.  Could you try the fix reported there:
>
>http://marc.theaimsgroup.com/?l=linux-scsi&m=112398346008284
>
>And see if it works for you?
>  
>
That seems to fix it. Thanks.

    Mark
