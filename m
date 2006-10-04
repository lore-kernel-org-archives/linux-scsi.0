From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] aic94xx: Hotplug ex_change_count race fix
Date: Wed, 4 Oct 2006 00:39:28 -0700 (PDT)
Message-ID: <20061004073928.93932.qmail@web31814.mail.mud.yahoo.com>
References: <4522D3C0.6060706@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31814.mail.mud.yahoo.com ([68.142.206.167]:36273 "HELO
	web31814.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1161119AbWJDHj3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 03:39:29 -0400
In-Reply-To: <4522D3C0.6060706@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

--- Jeff Garzik <jeff@garzik.org> wrote:
> Luben Tuikov wrote:
> > You have to make a clarification: "the way event processing works" means
> > the way it works after you removed all of event processing from my code the
> > way I wrote it, and added a very naive "event processing" if it can be
> > called that.
> > 
> > Event processing seems to work just fine with my version of my code the
> > way I maintain it, and the way you had it originally on this list.
> > 
> > Just clarifying in case someone gets confused reading the code.
> 
> And we were all waiting breathlessly for this clarification too, I 
> assure you.
> 
> In the dictionary under the phrase "sore loser", it says "see: Luben"

Sorry that you feel this way Jeff and that your have to resort
to personal attacks.  It makes me doubt your professionalism.

Merely on technical grounds and the fact that the code still
bears my copyright, I wanted to mention that all those bugs
being posted against aic94xx and the SAS Stack, and "fixed" by
Bottomley and LTC are not due to the reason that I wrote the
code with bugs, but due to the fact of Bottomley blocking the code
from going in, then him and LTC removing large portions of perfectly well
working and tested code (SAS analysed and complient) with their
own versions and interpretations, only later to "fix" the very code
they submitted as a substition of a perfectly working code I wrote
that they removed.

For example, event management is one such:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115895097501842&w=2

Another example, commit 2908d778ab3e244900c310974e1fc1c69066e450,
http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2908d778ab3e244900c310974e1fc1c69066e450
has things in it like this:
    ...
    o Preliminary expander support for aic94xx
    ...
All the while aic94xx and the SAS Stack had always supported
expanders.  There is just a lot of misleading information,
and I don't want the casual reader to believe that aic94xx
and the SAS Stack as I posted them didn't support expanders
all the while they did.

And I'm sure you don't want such confusion too and as a member
of the open source community will do everything in your power
to disambiguate that.  For example mentioning the announcement
emails of the very first posting of the SAS Stack and aic94xx:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629423714248&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509826900&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509318354&w=2

The tricky point is that aic94xx and the SAS Stack were
*NOT* committed into git as I had posted them, but were
first _edited_ and then "fixed" by what you see in
commit 2908d778ab3e244900c310974e1fc1c69066e450,
http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2908d778ab3e244900c310974e1fc1c69066e450
and _then_ commited into git as you'd see them starting
with the commit id quoted above.

Surely there are a lot of people just reading this mailing list,
interested in where storage is going with Linux. You don't want
to mislead them... Not to mention SATL support.

I should probably post my git trees somewhere?  The SAS Stack
now also includes enterprise-grade per-device SATL support.
I'm sure you'd enjoy that the most. ;-)

> 
> 	Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 




