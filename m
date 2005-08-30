From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [dm-devel] Re: fibre channel/multipath questions
Date: Tue, 30 Aug 2005 13:42:39 +0200
Message-ID: <1125402160.3224.30.camel@laptopd505.fenrus.org>
References: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
	 <20050829172316.GC7875@infradead.org> <1125378108.6375.15.camel@zezette>
	 <200508301119.24072.Rik.Bobbaers@cc.kuleuven.be>
	 <1125393973.3224.16.camel@laptopd505.fenrus.org>
	 <431444F3.90305@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47036 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751373AbVH3Lms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 07:42:48 -0400
In-Reply-To: <431444F3.90305@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>, christophe varoqui <christophe.varoqui@free.fr>


> > there is mount-by-label (filesystem label that is) that at least Fedora
> > and RHEL distros use, and I assume many other distros support too even
> > if they don't use it by default.
> 
> Although I don't really know what mount-by-label on Fedora and RHEL 
> means precisely, I suspect it may not help with the _bootloader_ 

correct; the bootloader is a very tricky thing to get right no matter
what you try; EDD seems to be the only real way there

> and/or 
> with RAID device files.

raid autodiscovery works pretty well actually


