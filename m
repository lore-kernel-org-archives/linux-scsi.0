From: alex@pilosoft.com
Subject: Re: IP/ethernet/networking-over-SCSI.
Date: Tue, 25 Jan 2005 14:06:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0501251402390.491-100000@bawx.pilosoft.com>
References: <20050125110113.54cf5725@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from neteng.pilosoft.com ([66.250.55.66]:20953 "EHLO
	bawx.pilosoft.com") by vger.kernel.org with ESMTP id S262077AbVAYTPr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 14:15:47 -0500
In-Reply-To: <20050125110113.54cf5725@dxpl.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <shemminger@osdl.org>
Cc: S Iremonger <exxsi@bath.ac.uk>, linux-net@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 25 Jan 2005, Stephen Hemminger wrote:

> On Tue, 25 Jan 2005 16:19:12 +0000 (GMT) S Iremonger <exxsi@bath.ac.uk>
> wrote:
> 
> > 
> > For some purposes at the moment, working IP-over-SCSI could be rather
> >   handy... ;-).
> 
> You probably are looking for:
> 	http://linux-iscsi.sourceforge.net/
Nah, iscsi is SCSI protocol over IP. The original poster wants the reverse 
- IP over SCSI :)

There was some work a long time ago to do this, mostly for curiosity sake:

One link is http://w3.ualg.pt/~dubuf/ipscsi.html

There's even RFC2143 that specifies a packet format for crazy people who 
want to do this.

Few benefits of those that could be thought - u320 scsi is essentially 
3gbps of bandwidth. SCSI has natural support for jumbo packets - SCSI 
packet can be 256kbytes in size. 

-alex

