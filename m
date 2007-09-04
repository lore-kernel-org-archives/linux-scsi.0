From: Parav Pandit <paravpandit@yahoo.com>
Subject: Re: state of the I/O memory when arrives at low level HBA driver
Date: Tue, 4 Sep 2007 05:02:37 -0700 (PDT)
Message-ID: <788706.48115.qm@web30112.mail.mud.yahoo.com>
References: <547218.81228.qm@web30103.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30112.mail.mud.yahoo.com ([209.191.69.44]:47117 "HELO
	web30112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752220AbXIDMCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2007 08:02:38 -0400
In-Reply-To: <547218.81228.qm@web30103.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

o.k. I got the answer.

It is already been locked when it comes to the low
level HBA driver.

Thanks,
Parav

--- Parav Pandit <paravpandit@yahoo.com> wrote:

> Hi,
> 
> This may be petty question, but I am not really sure
> about this.
> 
> When a I/O comes to the low level SCSI HBA driver
> through enqueue() interface, 
> 
> can it happen that I/O data memory is paged out or
> can
> be paged out?
> 
> I mean, doing DMA mapping such as pci_map_single()
> provides, just physical addresses or it also
> (page-in
> if requires) followed by locking the page(s) in the
> system?
> 
> Regards,
> Parav Pandit
> 
> 
> 
>        
>
____________________________________________________________________________________
> Boardwalk for $500? In 2007? Ha! Play Monopoly Here
> and Now (it's updated for today's economy) at Yahoo!
> Games.
>
http://get.games.yahoo.com/proddesc?gamekey=monopolyherenow
>  
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 



       
____________________________________________________________________________________
Need a vacation? Get great deals
to amazing places on Yahoo! Travel.
http://travel.yahoo.com/
