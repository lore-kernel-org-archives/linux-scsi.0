From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Areca RAID driver remaining items?
Date: Mon, 20 Feb 2006 19:11:19 +0100
Message-ID: <1140459079.2979.70.camel@laptopd505.fenrus.org>
References: <1140458552.3495.26.camel@mentorng.gurulabs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:150 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161100AbWBTSLY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 13:11:24 -0500
In-Reply-To: <1140458552.3495.26.camel@mentorng.gurulabs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dax Kelson <dax@gurulabs.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, erich@areca.com.tw, oliver@neukum.org


> "There's lots of architectural problems.  It's doing it's own queueing,
> it's stuffing kernel structures into memory on the hardware and so on.
> Basically someone knowledgeable about the hardware needs to start from
> scratch on it."
> 
> What are the show stoppers that prevents a merge into the Linus tree?

own queueing for sure is a show stopper; 
stuffing kernel structures into the hw is also very much evil


