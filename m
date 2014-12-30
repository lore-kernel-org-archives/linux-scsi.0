From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical
 max_hw_sectors cap")
Date: Tue, 30 Dec 2014 08:54:20 -0800
Message-ID: <1419958460.2164.7.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1412301132130.32416-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1412301132130.32416-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>, "Kenneth R. Crudup" <kenny@panix.com>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-12-30 at 11:45 -0500, Alan Stern wrote:

> PS: What's the current situation of my "SCSI: fix regression in 
> scsi_send_eh_cmnd()" patch:
> 
> 	http://marc.info/?l=linux-scsi&m=141658469207765&w=2
> 
> submitted on November 21?  Since it was a bug-fix, I rather expected it 
> to get merged before 3.18 was released.  Since it didn't, I certainly 
> hope it will get in before 3.19.

Looks like it just got overlooked.  Since Hannes has reviewed it, I'll
add it to the fixes branch.

James



