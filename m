From: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Subject: RE: Sg_ses question
Date: Wed, 23 May 2007 20:29:11 -0000
Message-ID: <861B5CF71BC70C478DFEB9EAFE98F699023A9532@G3W0068.americas.hpqcorp.net>
References: <861B5CF71BC70C478DFEB9EAFE98F6990233CAA7@G3W0068.americas.hpqcorp.net> <4653529B.9080100@torque.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:50701 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbXEWU3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 16:29:17 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4653529B.9080100@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Douglas Gilbert
> Sent: Tuesday, May 22, 2007 1:29 PM
> To: Haefliger, Juerg
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: Sg_ses question
> 
> Haefliger, Juerg wrote:
> > Hi,
> > 
> > Not sure if this is the right list for my question but I 
> couldn't find 
> > a more suitable place to ask it.
> > 
> > I'm trying to set the locator light of a disk in a SAS 
> enclosure using 
> > sg_ses but I'm not getting anywhere. I'm dumping the 
> enclosure status 
> > diagnostic page using 'sg_ses --page=2 --raw /dev/sgXX > page' and 
> > then set the SELECT and RQST IDENT bits of the array device 
> element in 
> > question and write it back doing 'sg_ses --control --page=2 
> --data=- 
> > /dev/sgXX < tmp'. The command completes without error but 
> > unfortunately, nothing happens. When I read the page back, 
> the IDENT 
> > bit is still cleared and the light on the enclosure remains 
> turned off.
> > 
> > Am I doing something wrong or am I missing something? Can't I use 
> > sg_ses to achieve this?
> 
> The procedure looks correct. I haven't had any (other) 
> reports of sg_ses not working lately. The only suggestion I 
> can make is to ask if you have selected the element control 
> rather than the overall control.

Hmm... Just tried it again and now it works. I don't think I did
something different than before...

Thanks
...juerg

 
> Doug Gilbert
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
