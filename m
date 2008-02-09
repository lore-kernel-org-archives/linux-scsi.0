From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Date: Sat, 9 Feb 2008 13:50:20 +0000
Message-ID: <20080209135020.6eca03ac@core>
References: <20080208153217.5fc42a50@core>
	<47AD02C6.70402@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44037 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755189AbYBIN46 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 08:56:58 -0500
In-Reply-To: <47AD02C6.70402@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 20:32:54 -0500
Douglas Gilbert <dougg@torque.net> wrote:

> Alan Cox wrote:
> > The word "illegal" has a precise dictionary meaning of "prohibited by
> > law". 
> 
> Also "contrary to or forbidden by official rules, regulations, etc".

The OED I have here doesn't seem to think so, however if the words are
the ones used in the T10 documentation then I'm happy to drop the patch.

Alan
