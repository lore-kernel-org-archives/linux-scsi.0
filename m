From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: MVSAS status
Date: Wed, 10 Feb 2010 10:39:44 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002101038300.31777@uplift.swm.pp.se>
References: <loom.20100210T002935-813@post.gmane.org> <333bc7e11002100122m5eb97d7ey78a31df91dee2405@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:57839 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab0BJJtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 04:49:33 -0500
Received: from localhost (localhost [127.0.0.1])
	by uplift.swm.pp.se (Postfix) with ESMTP id CE8839A
	for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2010 10:39:44 +0100 (CET)
In-Reply-To: <333bc7e11002100122m5eb97d7ey78a31df91dee2405@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 10 Feb 2010, Audio Haven wrote:

> I believe the current MVSAS patches should be good enough if you avoid 
> WD Green drives;

WHen I used those patches I get panics when hotswapping drives and I think 
people say it won't work with SMART either? So they seem to need more work 
to be included in regular kernel?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
