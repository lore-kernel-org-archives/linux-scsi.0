From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.19-rc6 : Spontaneous reboots, stack overflows - seems to
	implicate xfs, scsi, networking, SMP
Date: Thu, 23 Nov 2006 19:37:00 +0100
Message-ID: <1164307020.3147.3.camel@laptopd505.fenrus.org>
References: <9a8748490611211551v2ebe88fel2bcf25af004c338a@mail.gmail.com>
	 <20061122.201013.112290046.davem@davemloft.net>
	 <20061123070837.GV11034@melbourne.sgi.com>
	 <200611231416.03387.netdev@axxeo.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:30152 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1755210AbWKWShI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Nov 2006 13:37:08 -0500
In-Reply-To: <200611231416.03387.netdev@axxeo.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Oeser <netdev@axxeo.de>
Cc: David Chinner <dgc@sgi.com>, David Miller <davem@davemloft.net>, jesper.juhl@gmail.com, chatz@melbourne.sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, netdev@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2006-11-23 at 14:16 +0100, Ingo Oeser wrote:
> Hi there,
> 
> David Chinner schrieb:
> > If the softirqs were run on a different stack, then a lot of these

softirqs DO run on their own stack!


