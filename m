From: "Andrew Kinney" <andykinney@advantagecom.net>
Subject: Re: aacraid died on kernel 2.4.27
Date: Fri, 11 Mar 2005 13:34:10 -0800
Message-ID: <42319E52.19095.2CDA5B5A@localhost>
References: <60807403EABEB443939A5A7AA8A7458BE5A9C9@otce2k01.adaptec.com> (Mark Salyzyn's message of "Fri, 11 Mar 2005 11:06:47 -0500")
Reply-To: andykinney@advantagecom.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from mail.advantagecom.net ([65.103.151.155]:45225 "EHLO
	mail.advantagecom.net") by vger.kernel.org with ESMTP
	id S261468AbVCKVgL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 16:36:11 -0500
In-reply-to: <87br9plyaf.fsf@tapsellferrier.co.uk>
Content-description: Mail message body
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Ferrier <nferrier@tapsellferrier.co.uk>
Cc: linux-scsi@vger.kernel.org

On 11 Mar 2005 at 20:31, Nic Ferrier wrote:

> The machine I am having trouble with has been running MS Windows for 2
> years.
> 
> I just put linux on it (with no other changes) and we get regular
> (twice daily) catastrophic crashes.
> 
> Can this be a controller problem? I'm not a hardware expert but it
> doesn't sound like one to me.

It can be a controller problem, but it can also be a drive problem, 
cable problem, firmware problem, or a backplane problem.  We had a 
similar instance that was resolved by replacing the drive with a 
different brand, replacing the backplane, replacing the cabling, 
replacing the ROMB, and getting the newest firmware.  Now, drives 
fail gracefully instead of taking the whole container offline.  Who 
knows what the actual cause was, but the problem is fixed and that's 
what I was looking for.

Like Mark S. said, many causes, one symptom.  That Dell trouble 
ticket is going to be the best way to get it solved.  Their Linux 
guys have seen it all and can escalate it to an engineer if they 
haven't.  They're going to ask you for the diagnostic output of 
afacli, so you'll want to get that installed if you haven't already.  
They can also swap in new components for you.

Sincerely,
Andrew Kinney
President and
Chief Technology Officer
Advantagecom Networks, Inc.
http://www.advantagecom.net



