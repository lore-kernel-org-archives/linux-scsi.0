From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Kernel deadlock ??
Date: Thu, 17 Feb 2005 12:22:04 +0000
Message-ID: <20050217122204.GS29917@parcelfarce.linux.theplanet.co.uk>
References: <679DD756E54E6A4FB53BBF741A8D5BA79330DD@sydxchmb1.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:31917 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262233AbVBQMWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 07:22:10 -0500
Content-Disposition: inline
In-Reply-To: <679DD756E54E6A4FB53BBF741A8D5BA79330DD@sydxchmb1.veritas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Harvey <mark.harvey@veritas.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 16, 2005 at 10:03:04PM -0800, Mark Harvey wrote:
> I also do not understand what 'Rusty Russel refers to as being in user
> context (Unreliable Guide to Hacking the Linux kernel)' Chapter 5:
> Recipes for Deadlock.

>From the same Unreliable Guide ...

  <sect1 id="basics-usercontext">
   <title>User Context</title>

   <para>
    User context is when you are coming in from a system call or
    other trap: you can sleep, and you own the CPU (except for
    interrupts) until you call <function>schedule()</function>.  
    In other words, user context (unlike userspace) is not pre-emptable.
   </para>


-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
