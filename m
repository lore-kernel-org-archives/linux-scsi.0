From: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Subject: RE: Mid-layer API?
Date: Mon, 23 Oct 2006 16:56:24 -0500
Message-ID: <861B5CF71BC70C478DFEB9EAFE98F699ACB0DD@G3W0068.americas.hpqcorp.net>
References: <20061020172549.7666.qmail@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:25736 "EHLO
	ccerelbas03.cce.hp.com") by vger.kernel.org with ESMTP
	id S1752034AbWJWV40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2006 17:56:26 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20061020172549.7666.qmail@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com, linux-scsi@vger.kernel.org

Hi Luben,

> > I'm using the Linux box as a 'dumb' SCSI adapter.
> 
> You just answered your question!

Hmm... OK...
 
> > The SCSI commands are
> > received by a driver that manages a proprietary interface through 
> > which the commands are coming in from a remote host. The 
> driver then 
> > needs to forward the commands to the FC disk (by means I'm 
> trying to 
> > figure out here :-) and pass the results back up to the host.
> 
> You again answered your own question.

Hmmmmmm....
  
> > I guess my biggest problem is that I don't fully understand 
> the flow 
> > of command and data through the different layers.
> 
> Take a look at the scsi_host template, and the document Randy 
> mentioned.

I did but I still don't get it :-) In fact I'm more confused now. Why
host_template? Isn't that function used to register an LLD with the
mid-layer? I'm trying to tap into the other side of the mid-layer.

Thanks
...juerg


>     Luben
