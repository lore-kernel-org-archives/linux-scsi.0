From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: IP/ethernet/networking-over-SCSI.
Date: Tue, 25 Jan 2005 15:16:37 -0500
Message-ID: <200501252014.j0PKEe903540@www.watkins-home.com>
References: <Pine.LNX.4.44.0501251402390.491-100000@bawx.pilosoft.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:58053 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262098AbVAYUOn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 15:14:43 -0500
In-Reply-To: <Pine.LNX.4.44.0501251402390.491-100000@bawx.pilosoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: alex@pilosoft.com, 'Stephen Hemminger' <shemminger@osdl.org>
Cc: 'S Iremonger' <exxsi@bath.ac.uk>, linux-net@vger.kernel.org, linux-scsi@vger.kernel.org

Great!  Now you can have ISCSI over SCSI!  :)

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of alex@pilosoft.com
Sent: Tuesday, January 25, 2005 2:07 PM
To: Stephen Hemminger
Cc: S Iremonger; linux-net@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: IP/ethernet/networking-over-SCSI.

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

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

