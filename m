From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Wed, 05 Oct 2005 13:22:56 +0200
Message-ID: <1128511377.2920.17.camel@laptopd505.fenrus.org>
References: <200510051314.33411.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15800 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965115AbVJELXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 07:23:00 -0400
In-Reply-To: <200510051314.33411.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2005-10-05 at 13:14 +0200, Andi Kleen wrote:
> In 2.6.14rc3:
> 
> linux/drivers/scsi> grep -c BROKEN Kconfig
> 11
> 
> There are a lot of SCSI drivers who have been marked BROKEN forever. Or at 
> least for all of 2.6 and one would expect if there are users left they would 
> have fixed them by now. Would it make sense to remove them?

I'd say so yes


> I think they could all go except perhaps the MCA driver. Or at least added
> to Documentation/feature-removal-schedule.txt and then removed in a few 
> months.

sounds like the feature-removal should be done now before 2.6.14, and
the removal right after 2.6.14 goes out (if anyone later wants to revive
a driver they can always find the driver in the 2.6.14 tarbal after all)


