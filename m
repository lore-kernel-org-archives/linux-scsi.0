From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata update posted (was Re: VIA Serial ATA chipset)
Date: Fri, 29 Aug 2003 13:59:55 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F4F949B.6030900@pobox.com>
References: <20030813074535.C3AB427AC8@mail.medav.de> <3F4F6863.4080400@pobox.com> <3F4F8BA7.1080002@rackable.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3F4F8BA7.1080002@rackable.com>
To: Samuel Flory <sflory@rackable.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Samuel Flory wrote:
> Jeff Garzik wrote:
>> Changes:
>> * continue work towards fully async taskfile API:  you call 
>> submit_tf(), and later on, your callback is called when the taskfile 
>> completes or times out.   async taskfile API is required for ATAPI and 
>> supporting more advanced host controllers like Promise or AHCI (SATA2).
>> * some cleanups

>   I'm guessing there is no support for Promise yet?

Not yet.  Once I finish the item mentioned above, "async taskfile API", 
Promise support will appear quite rapidly.


> PS-  The driver works great on the silcon image chipset.  (Once I 
> realized that my Seagate drive needed newer firmware.)

Um... libata doesn't support Silicon Image yet?

	Jeff
