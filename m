From: Rabeeh Khoury <rabeeh@il.marvell.com>
Subject: Re: Linux limitation of amount of SCSI buses
Date: Tue, 29 Jul 2003 20:34:27 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F26B023.7090503@il.marvell.com>
References: <3F266F60.5070501@il.marvell.com> <20030729155841.GE8407@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop3.galileo.co.il ([199.203.130.130]:20665 "EHLO
	mail.galileo.co.il") by vger.kernel.org with ESMTP id S271938AbTG2RfH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 13:35:07 -0400
In-Reply-To: <20030729155841.GE8407@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

>
>
>>I'm connecting few cards with 24 buses and Linux gives me only 15 buses.
>>Is there any limitation in Linux SCSI subsystem within kernel 2.4.x of 
>>the number of SCSI buses ?
>>Each bus has a single target and a single LUN.
>>    
>>
>
>Does each card have multiple channels (i.e., 24)? If so you may need to
>set max_channel to a higher value.
>
Each card has 8 buses ; total 3 cards. On each bus I have a single 
target that has single LUN.
If I work with a single adapter I can see 8 buses.

>
>If each card has a single bus there may be a instance limit that the
>driver you are using will support.
>
>What driver are you using?
>
Internal driver that is under development.

>
>-andmike
>--
>Michael Anderson
>andmike@us.ibm.com
>
>
>.
>  
>

