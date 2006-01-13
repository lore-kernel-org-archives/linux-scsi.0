From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym53c8xx phase change log suppression
Date: Fri, 13 Jan 2006 13:15:50 -0700
Message-ID: <20060113201550.GR19769@parisc-linux.org>
References: <20060113200200.GB12885@paradise.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:17328 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1422920AbWAMUPt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 15:15:49 -0500
Content-Disposition: inline
In-Reply-To: <20060113200200.GB12885@paradise.net.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Volker Kuhlmann <list0570@paradise.net.nz>
Cc: linux-scsi@vger.kernel.org

On Sat, Jan 14, 2006 at 09:02:00AM +1300, Volker Kuhlmann wrote:
> I get a huge number of these phase change entries in syslog, just about
> with ever SCSI transfer. That's with a scanner anyway, on AMD64. As they
> seem to be harmless, this patch allows to prevent syslog being filled
> by using verb=0. Perhaps verb=1 should also suppress it?

Did you not read the email I sent to you earlier where I explained
why this patch wasn't necessary?
