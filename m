From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 08:46:50 -0600
Message-ID: <20070927144649.GV3899@parisc-linux.org>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com> <CE7B1A4EF22E704CBFFD9A35BA5C822252505C@ausx3mpc110.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49481 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbXI0Oqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 10:46:52 -0400
Content-Disposition: inline
In-Reply-To: <CE7B1A4EF22E704CBFFD9A35BA5C822252505C@ausx3mpc110.aus.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick_Boyd@Dell.com
Cc: James.Smart@Emulex.Com, jeff@garzik.org, linux-scsi@vger.kernel.org

On Thu, Sep 27, 2007 at 09:16:13AM -0500, Patrick_Boyd@Dell.com wrote:
> Unfortunately, it looks like IEEE doesn't have any OID's registered for
> Linux or other reserved areas
> (http://standards.ieee.org/regauth/oui/oui.txt). However, it does look
> like they go in order... so maybe if you used an OID of 0xFFFFFF you
> could at least guarantee that you didn't conflict with any company's SAS
> WWNs.

It's something that happens frequently enough that we should come up
with a proper way of handling this.  I heard a story of someone at HP
taking an old computer, reading the MAC address from the motherboard,
then snapping the board in half.  I suppose if you're going to use a MAC
address from a 10Mbit ethernet card for a SAS WWN, there's no chance of
conflict, but still ... 3com might choose to do the same thing, and then
we're in trouble.

I don't have a good solution for WWN assignment.  Even if we get a
24-bit OID assignment for 'software use' or something, how do we control
the use withi the SAN to be sure we get no overlapping WWNs?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
