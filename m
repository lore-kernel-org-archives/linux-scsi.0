From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Tue, 19 Oct 2004 17:52:38 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410191738250.713-100000@netrider.rowland.org>
References: <41758003.2060005@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:18948 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S269913AbUJSVwm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 17:52:42 -0400
In-Reply-To: <41758003.2060005@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 19 Oct 2004, Luben Tuikov wrote:

> Alan, do you have such a USB device handy?

I don't have one myself, but I know several users who do.

> A third possibility is to use the PMI bit to get the proper value
> of the LBA of the last logical block.
> 
> If you want to move this into sd, then do you know if those
> devices support the use of PMI bit in READ CAPACITY CDB?
> As block devices they should.

I don't know.  Yes, they should -- but considering that the READ CAPACITY 
support is wrong it wouldn't be surprising if the PMI support is also 
wrong.  There's an excellent chance the devices will return the same value 
whether PMI is set or not.

> See the appended/attached patch.  Can you test it against such a USB
> device?

I'll ask some people to try.  Do you think that READ FORMAT CAPACITIES (op
0x23) might be a better approach?

Alan Stern

