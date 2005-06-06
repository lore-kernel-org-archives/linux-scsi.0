From: Denis Zaitsev <zzz@anda.ru>
Subject: Re: [PROBLEM] aic7xxx: DV failed to configure device
Date: Mon, 6 Jun 2005 15:03:22 +0600
Message-ID: <20050606150321.A817@ward.six>
References: <20050606141638.A28532@ward.six> <1118045986.5652.21.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw.anda.ru ([83.146.86.58]:18181 "EHLO mail.ward.six")
	by vger.kernel.org with ESMTP id S261239AbVFFJD2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2005 05:03:28 -0400
Content-Disposition: inline
In-Reply-To: <1118045986.5652.21.camel@laptopd505.fenrus.org>; from arjan@infradead.org on Mon, Jun 06, 2005 at 10:19:45AM +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jun 06, 2005 at 10:19:45AM +0200, Arjan van de Ven wrote:
> On Mon, 2005-06-06 at 14:16 +0600, Denis Zaitsev wrote:
> > I'm testing an Adaptec SCSI controller + an IBM drive.  All the things
> > used to be fine before I had made the low-level format of the drive
> > (thru the Ctrl-A Adaptec's menu).  And now after
> > 
> >         modprobe aic7xxx
> 
> 
> you failed to mention which exact kernel you were using...

Yes, I'm sorry.  2.6.10.
