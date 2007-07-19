From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Thu, 19 Jul 2007 14:52:33 +0200
Message-ID: <20070719145233.6c66e584@gondolin.boeblingen.de.ibm.com>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
	<20070719112602.5e3cb21a@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.62.0707191132150.8661@pademelon.sonytel.be>
	<20070719140038.606abd44@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.62.0707191411060.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:32101 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbXGSMwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 08:52:11 -0400
In-Reply-To: <Pine.LNX.4.62.0707191411060.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

On Thu, 19 Jul 2007 14:13:33 +0200 (CEST),
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> Any chance this will change? I already added a mutex to ps3disk to protect
> against this.

Probably not in the near future. A mutex looks like a good idea though,
since one never knows (and the driver core generally doesn't make many
guarantees regarding serialization).
