From: Mark Lord <liml@rtr.ca>
Subject: Re: Discard support
Date: Sun, 16 Aug 2009 18:51:23 -0400
Message-ID: <4A888D6B.8020103__41284.5616032884$1250463113$gmane$org@rtr.ca>
References: <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com> <20090814234539.GE27148@parisc-linux.org> <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com> <1250341176.4159.2.camel@mulgrave.site> <4A86B69C.7090001@rtr.ca> <1250344518.4159.4.camel@mulgrave.site> <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk> <20090816083434.2ce69859@infradead.org> <1250437927.3856.119.camel@mulgrave.site> <adavdkn2ztb.fsf@cisco.com> <20090816221325.GF17958@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:48435 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308AbZHPWvX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Aug 2009 18:51:23 -0400
In-Reply-To: <20090816221325.GF17958@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Roland Dreier <rdreier@cisco.com>, James Bottomley <James.Bottomley@suse.de>, Arjan van de Ven <arjan@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

Theodore Tso wrote:
> On Sun, Aug 16, 2009 at 02:50:40PM -0700, Roland Dreier wrote:
>>  > Well, yes and no ... a lot of SSDs don't actually implement NCQ, so the
>>  > impact to them will be less ... although I think enterprise class SSDs
>>  > do implement NCQ.
>>
>> Really?  Which SSDs don't implement NCQ?
> 
> The Intel X25-M was the first SSD to implement NCQ.  The OCZ Core V2
> advertised NCQ with a queue depth of 1, but even that was buggy, so
> Linux has a black list for the that SSD:
> 
>       http://markmail.org/message/jvjpmcdqjwrmyl4w
> 
> As far as I know, all of the SSD's using the crappy JMicron JMF602
> controllers don't support NCQ in any real way, which would includes
> most of the reasonably priced SSD's up until first half of this year.
> (The OCZ Summit SSD, which uses the Indilnx controller is an exception
> to this statement, but it's more expensive that the JMF602 based
> SSD's, although less expensive than the Intel SSD.)
> 
> JMicron is trying to seek redemption with their JMF612 controllers,
> which were announced at the end of May of this year, and those
> controllers do support NCQ, and are claimed to not to have the
> disatrous small write latency problem of their '602 bretheren.  I'm
> not aware of any products using the JMF612 yet, though.  (According to
> reports the '612 controllers weren't going to hit mass production
> until July, so hopefully later this fall we'll start seeing products
> using the new JMicron controller.)
..

Great summary, Ted.

To add:  SSDs based upon the Indilinx controller don't appear to scale
beyond an NCQ depth of about 4 or so.  Whereas Intel SSDs continue to
improve with increased queue depth up to 31 on Linux.

Or at least that's what I recall from reading various SSD benchmarks
a few weeks ago here. 

Cheers
