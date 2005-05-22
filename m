From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Sd driver on kernel 2.6
Date: Sun, 22 May 2005 22:17:36 +0200
Message-ID: <1116793056.6285.32.camel@laptopd505.fenrus.org>
References: <4290E5B7.2090300@netstorage.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49630 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261213AbVEVURm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 May 2005 16:17:42 -0400
In-Reply-To: <4290E5B7.2090300@netstorage.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aldo Gavioli <aldo.gavioli@netstorage.it>
Cc: linux-scsi@vger.kernel.org

On Sun, 2005-05-22 at 22:04 +0200, Aldo Gavioli wrote:
> Hello All,
> I'm trying to attach one proprietary SCSI driver for optical disk on 
> kernel 2.6.

did you or your company write this driver with linux in mind or even
specifically for linux ?

> I noted that if sd attach the same device before my driver will never be 
> called in the probe function.
> How can I by-pass this situation ?
> If anyone can help me I appreciate very much.

it sounds like it's best that you improve the sd driver to work with
your device... or otherwise show your code so that the people on this
mailing list can actually see what the problem is.



