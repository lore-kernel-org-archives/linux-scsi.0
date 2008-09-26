From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI driver submission (2nd try)
Date: Fri, 26 Sep 2008 06:22:19 -0600
Message-ID: <20080926122219.GV27204@parisc-linux.org>
References: <200809260054.m8Q0slEL027478@swe37.brocade.com> <200809260841.39433.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37091 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYIZMWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 08:22:21 -0400
Content-Disposition: inline
In-Reply-To: <200809260841.39433.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Jing Huang <huangj@brocade.com>, James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, srayas@brocade.com, vravindr@brocade.com

On Fri, Sep 26, 2008 at 08:41:31AM +0200, Rolf Eike Beer wrote:
> You should use pcim_enable_device(). This would help you by simplifying your 
> error and release code as it keeps track of freeing a bunch of resources. See 
> Documentation/driver-model/devres.txt.

I hate the devres stuff.  It takes care of most things behind your back,
but is terribly complex code and makes bugs next to impossible to track
down.  Don't add more users for it unless you really, really have to.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
