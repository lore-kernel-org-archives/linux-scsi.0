From: Andreas Haumer <andreas@xss.co.at>
Subject: Re: patch so cciss stats are collected in /proc/stat
Date: Wed, 29 Sep 2004 18:58:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415AE9CF.40008@xss.co.at>
References: <D4CFB69C345C394284E4B78B876C1CF107DBFE0B@cceexc23.americas.cpqcorp.net> <1096476186.2786.45.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from camus.xss.co.at ([194.152.162.19]:16915 "EHLO camus.xss.co.at")
	by vger.kernel.org with ESMTP id S268710AbUI2RAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 13:00:05 -0400
In-Reply-To: <1096476186.2786.45.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: "Miller, Mike (OS Dev)" <mike.miller@hp.com>, Christoph Hellwig <hch@infradead.org>, mikem@beardog.cca.cpqcorp.net, marcelo.tosatti@cyclades.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Baker, Brian (ISS - Houston)" <brian.b@hp.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Arjan van de Ven wrote:
> On Wed, 2004-09-29 at 18:29, Miller, Mike (OS Dev) wrote:
>
>
>>>This patch has been reject about half a million times, why are people
>>>submitting it again and again?
>>
>>As I said in my mail, it's a customer driven issue. As long as customers rely on /proc/stat we'll keep trying. You can't tell a customer how he/she should be doing things on their systems.
>
>
> I doubt you have many customers using 2.4.28.... I suspect that by now
> the majority of people is either using an (ancient) 2.4 vendor kernel or
> a 2.6 kernel. The very low number of reports on lkml about 2.4 seems to
> confirm that ...

"25% of accidents are caused by drunken drivers. That means
75% of accidents are caused by drivers which did not drink.
So why keep people complaining about alcohol and driving?"

Is that what you mean? You must be kidding!

The majority of _our_ customers are using 2.4.x kernels
(x beeing in the range from 19 to 28pre3) and it looks like
it will stay that for quite a while...

- - andreas

PS: I know this is somewhat off topic, but I just want to raise
my voice if I get the impression kernel developers forget about
the "real world outside". I will shut up in a moment! Thank you!

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFBWum9xJmyeGcXPhERArzMAKCYhHvVvwpFObCzrPby2qY9u9MURQCgrelJ
BpeZ2tG8zw0po/5ByYKFuZk=
=RlQc
-----END PGP SIGNATURE-----

