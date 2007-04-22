From: Srdjan Todorovic <todorovic.s@googlemail.com>
Subject: Re: InitIO SCSI: Volunteers required
Date: Sun, 22 Apr 2007 14:20:26 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0704221416440.5217@thor.lan>
References: <20070420103849.7358f1f1@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:38291 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030848AbXDVNMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2007 09:12:08 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1242169uga
        for <linux-scsi@vger.kernel.org>; Sun, 22 Apr 2007 06:12:07 -0700 (PDT)
In-Reply-To: <20070420103849.7358f1f1@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Alan Cox wrote:

> I'm looking for some testers for a revamp of the initio driver. No real
> code changes other than to hopefully stop it exploding on load on 64bit,
> but a major reorganisation, commenting and "de-windowsification" so the
> code is actually readable and I can do the pci_find_device to
> pci_get_device transitions.
> 
> Alan

I have such a card in my box right now, and would definitely be happy to
test any changes.

I also have a couple of patches for the driver, but need to regenerate
the diffs and test them. Hopefully I can do that sometime this coming
week, and I'll be sure to CC you when I post them to linux-scsi ML.

Thanks

Srdjan Todorovic
