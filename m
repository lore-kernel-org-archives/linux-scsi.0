From: christophe.varoqui@free.fr
Subject: Re: scsidev-2.30 released
Date: Mon, 11 Aug 2003 12:39:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060598355.3f3772538d3e3@impt3-2.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix3-1.free.fr ([213.228.0.44]:14798 "EHLO
	postfix3-1.free.fr") by vger.kernel.org with ESMTP id S272485AbTHKKjQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 06:39:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

>On Mon, Aug 11, 2003 at 02:50:50AM +0200, Kurt Garloff wrote:
>> New in 2.30:
>> * HSV devices are detected and HSV_OS_IDs retrieved. They can be used 
>>   to build aliases (Contributed by Evans Felix, PNL).
>
>What's HSV devices and HSV_OS_IDs?

It's a FC Raid controler from HPQ StorageWorks high end product line.
With a sort of a Volume Manager embeded : when a lun is created you can choose
to assign an ID (number) that hosts can use to assign a devname ...

the manual says :

"Some operating systems require a unique ID in order to assign the virtual disk
a device name; therefor each virtual disk may be assigned an operating
system-specific unit ID.
OS unit ID is the same as a LUN ID alias"

-- 
