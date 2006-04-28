From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 20:02:17 +0200
Message-ID: <1146247337.3126.28.camel@laptopd505.fenrus.org>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
	 <20060428172736.GA11321@infradead.org>  <20060428175521.GB18383@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37088 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751736AbWD1SCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 14:02:21 -0400
In-Reply-To: <20060428175521.GB18383@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>, Christoph Hellwig <hch@infradead.org>

On Fri, 2006-04-28 at 10:55 -0700, Mike Anderson wrote:
> Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Apr 28, 2006 at 11:54:05AM -0500, James Bottomley wrote:
> > > Could you send any bugs found back to linux-scsi (not the kernel
> > > bugzilla)?
> > 
> > not a bug strictly speaking, but it should stop including the firmware
> > blob and use request_firmware, similar to the discussion we had about
> > qla2xxx recently.  It would be even nicer if adaptec continued publishing
> > their sequencer code as with aic7xxx and aic79xx which look remarkably
> > similar, of course.
> 
> I added Rob to this thread so he could comment on this.
> 
> It would also be good before we put another card through this process that
> at least a few distros have the request_firmware infrastructure fully
> functional. I have seen indications that there where a few bumps in the
> road in getting this working.

that's also a chicken-and-egg problem. Sometimes someone needs to start
to make an omelette ;)


