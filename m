From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Thu, 4 Sep 2008 15:28:03 +0100
Message-ID: <20080904152803.6c4977ce@lxorguk.ukuu.org.uk>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	<48BD2136.1020101@garzik.org>
	<65a6ef750809020455q7b7ee6a8jc404b4970f660c50@mail.gmail.com>
	<18621.11426.870514.781750@harpo.it.uu.se>
	<65a6ef750809020521wfaca733r8253795860b95f4@mail.gmail.com>
	<48BFBA5E.5050300@garzik.org>
	<65a6ef750809040459h3ffe3183nf0b5a35d15ab86e4@mail.gmail.com>
	<48BFE5FA.9090006@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33136 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751833AbYIDO2z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 10:28:55 -0400
In-Reply-To: <48BFE5FA.9090006@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Nelson <mdnelson8@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

> > No need for hope - we have ahci now :)
> 
> Well, I still think this PCI ID addition leaves open the possibility 
> that plugging in a SAS disk could hang the system or similar misbehavior.

And not adding it means it doesn't work at all and you'll never find out
as you won't get the bug report from the SAS user 8)

Alan
