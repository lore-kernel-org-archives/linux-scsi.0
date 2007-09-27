From: Michael Reed <mdr@sgi.com>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 10:12:42 -0500
Message-ID: <46FBC86A.6090902@sgi.com>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com> <CE7B1A4EF22E704CBFFD9A35BA5C822252505C@ausx3mpc110.aus.amer.dell.com> <20070927144649.GV3899@parisc-linux.org> <46FBC723.2070607@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45502 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753992AbXI0PMo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 11:12:44 -0400
In-Reply-To: <46FBC723.2070607@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Patrick_Boyd@Dell.com, James.Smart@Emulex.Com, jeff@garzik.org, linux-scsi@vger.kernel.org



Michael Reed wrote:
> 
> Matthew Wilcox wrote:
>> On Thu, Sep 27, 2007 at 09:16:13AM -0500, Patrick_Boyd@Dell.com wrote:
>>>> Unfortunately, it looks like IEEE doesn't have any OID's registered for
>>>> Linux or other reserved areas
>>>> (http://standards.ieee.org/regauth/oui/oui.txt). However, it does look
>>>> like they go in order... so maybe if you used an OID of 0xFFFFFF you
>>>> could at least guarantee that you didn't conflict with any company's SAS
>>>> WWNs.
>> It's something that happens frequently enough that we should come up
>> with a proper way of handling this.  I heard a story of someone at HP
>> taking an old computer, reading the MAC address from the motherboard,
>> then snapping the board in half.  I suppose if you're going to use a MAC
>> address from a 10Mbit ethernet card for a SAS WWN, there's no chance of
>> conflict, but still ... 3com might choose to do the same thing, and then
>> we're in trouble.
> 
> Record the WWN of your SAS / FC port so that if/when it goes missing you
> can put it back?  Have spares on site?

Our vendor recommends fixing the board, not applying a band-aid.  A random
WWN will potentially not work as the board firmware does some level of
sanity checking.  YMMV.

Mike

> 
>> I don't have a good solution for WWN assignment.  Even if we get a
>> 24-bit OID assignment for 'software use' or something, how do we control
>> the use withi the SAN to be sure we get no overlapping WWNs?
> 
> Your point here is that overriding a WWN assignment is asking for trouble.
> 
> 
> Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
