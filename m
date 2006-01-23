From: Chase Venters <chase.venters@clientec.com>
Subject: Re: OOM Killer killing whole system
Date: Sun, 22 Jan 2006 21:28:50 -0600
Message-ID: <200601222129.12882.chase.venters@clientec.com>
References: <1137337516.11767.50.camel@localhost> <200601202235.48352.chase.venters@clientec.com> <dr1gl8$tec$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751397AbWAWD3T@vger.kernel.org>
In-Reply-To: <dr1gl8$tec$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kalin KOZHUHAROV <kalin@thinrope.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday 22 January 2006 20:56, Kalin KOZHUHAROV wrote:
> I have two of these boards and one of them is constantly hanging, just
> simply dead. With 2.6.15 it reports failed I/O (SATA here) and mounts
> reiserfs root RO. sky2 works for me, but I had another hang, so sk98lin
> might not be the culprit.

Really? I had serious problems with mine hanging in earlier kernel revisions. 
I haven't seen a hang yet on 2.6.15, but that may be because I've not made it 
to a longer uptime because of the scsi leak. 

When I hang I get complaints about DMA timeouts / weird ATA port statuses as 
the last messages on my serial console. After that, not even SysRQ works.

Cheers,
Chase
