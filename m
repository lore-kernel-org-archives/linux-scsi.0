From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] removel useless mod use count manipulation
Date: Mon, 18 Nov 2002 00:38:04 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD79BBC.2030701@torque.net>
References: <20021116204009.A24052@lst.de> <3DD78E4B.6040006@torque.net> <20021117134848.A4556@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Nov 17, 2002 at 11:40:43PM +1100, Douglas Gilbert wrote:
> 
>>Christoph Hellwig wrote:
>>
>>>There's a bunch of useless mod usecount handling in scsi:
>>
>>While playing with scsi_debug today I saw the opposite effect:
>>with a file system mounted on a scsi_debug fake disk **, lsmod
>>showed a zero "in use" count. I was able to "rmmod scsi_debug"
>>and crash the system when I tried to access that mounted fs.
> 
> 
> This change didn't change the use-count handling for HBA driver at all,
> so this must be something different.  Do you use a scsi_debug using
> scsi_add_host/scsi_remove_host?

Yes.

 > Try adding
> 
> 	.module		= THIS_MODULE,
> 
> to sdebug_driver_template, I forgot that change when sendig you the
> initial draft version of the change.

That fixed it. [Still have "missing" partition(s) problem.]

Thanks. New version of scsi_debug coming soon.

Doug Gilbert




