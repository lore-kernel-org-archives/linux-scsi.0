From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: two sym53c8xx.o modules
Date: Thu, 09 Oct 2003 18:05:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F858731.1020706@wanadoo.es>
References: <Pine.LNX.4.44.0310090826290.2569-100000@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Marcelo Tosatti wrote:

> One should not have both drivers loaded at the same time, so I think this
> is alright.

problem is "modprobe sym53c8xx" command loads at *same time* both.
I sent you a patch long time ago http://marc.theaimsgroup.com/?l=linux-kernel&m=105262722022952&w=2
;-)

-thanks-
