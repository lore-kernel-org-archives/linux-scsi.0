From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Fri, 28 May 2004 13:25:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528172535.GD13961@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:64390 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261897AbUE1RZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 13:25:43 -0400
Content-Disposition: inline
In-Reply-To: <40B74725.90403@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, alan@redhat.com

On Sat, May 29, 2004 at 12:05:25AM +1000, Douglas Gilbert wrote:
> The recently released Fedora Core 2 distribution contains
> a patch that allocates sg device names (e.g. /dev/sg0)
> only to those SCSI devices _not_ "claimed" by other upper

This is an error. Linus has also vetoed this change. Consider the
Fedora kernel wrong on this point. It isnt however your SG_IO issue I think

