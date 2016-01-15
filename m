From: Hannes Reinecke <hare@suse.de>
Subject: Re: very strange message: driver bug?
Date: Fri, 15 Jan 2016 11:03:27 +0100
Message-ID: <5698C3EF.7090901@suse.de>
References: <20160114154852.582817e9@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbcAOKDg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 05:03:36 -0500
In-Reply-To: <20160114154852.582817e9@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>, linux-scsi@vger.kernel.org

On 01/14/2016 03:48 PM, Emmanuel Florac wrote:
>
> On a machine running a plain vanilla 3.10.23 kernel (old, I know) on
> Debian Wheezy (7.3, not up to date either), with RAID arrays connecte=
d
> through an Adaptec ASR-6445 RAID controller (aacraid driver, version
> 30200), I've seen messages like below filling up /var/log/messages.
>
>
> Of course some hardware fault occurred, but I don't understand why th=
e
> message is so mangled. Could it be a driver bug? something else?
>
> Jan 13 18:40:28 storiq -- MARK --
> Jan 13 18:44:45 storiq kernel: <<3>sd 6:0:2:0: rejecting I/O to offli=
ne device
> Jan 13 18:45:10 storiq kernel: quiet_error: 6 callbacks suppressed
> Jan 13 18:45:10 storiq kernel: lost page write due to I/O error on dm=
-1
> Jan 13 18:45:10 storiq last message repeated 9 times
> Jan 13 18:45:15 storiq kernel: <3<3>sd<3>sd<3>s<3>s<3<3<3>sd<3><3>s<3=
><3>sd<3><3<3>s<<3><3><3>sd <3><<<3>sd <3><3<3>sd<<3><3>sd 6<3>sd<3>sd<=
3>sd<<3><3><3>s<3>s<3>sd <3><3>s<3>s<3><3>sd<3><3<3>s<<3>sd<3>sd<<3>s<3=
><3>s<3>sd<3>s<3<3>s<3>sd <3>sd<3><3><3><3>sd<3><3><3><3<3>s<<3<3><3<3<=
3><3><3><3><3>sd<3<3><3><3><3><<3>s<3>sd <3>sd <3>sd<3><3>sd<3>s<3>sd <=
3><3><<<3<3>s<3>sd <3>sd 6:0:2:0: re<3>s<3>s<3>s<3>sd<3>sd<3>sd<3>sd <<=
3>s<3>sd <3>sd <3>sd<3>sd <3>sd <<3>sd <3<3>sd<3><3>s<3<3>s<<3><3>sd<3>=
sd<3>sd<<3>sd<3>sd<3>sd<<3><3>s<3>s<3>sd<<3><3><3>sd<3<3><<3>sd <3>s<<3=
>s<<3>s<3>s<3>sd<3>sd <3>sd<<3>sd<3>sd<3><3>sd<<3>sd<3>sd<3>sd<3>sd<3><=
3>sd <3>s<3>sd <3>sd 6:<3><<3>s<3>s<3>s<3>sd<3>s<3>s<3>s<3>s<3>s<3>sd<3=
>s<3><3>s<3>sd<3><3>sd<3>s<3<3><3<3>sd<3><3<3>sd<<3>sd<3<3>s<3>sd <3><3=
><3>s<3>s<3>sd<3<3><3>s<3>s<3>sd 6:0:2:0: rejectin<3>sd <3>sd<<3><3<<3>=
s<3>sd <3><3>s<3<3><3>s<3>sd <3>sd <3>s<3>sd<3>sd 6<3>sd<3><3<3>sd <3>s=
d<3>s<3>sd <3><3><3>s<3<3>sd<3>s<3<3>s<3>sd <<3>sd<3><3><3>sd<3><3>s<3<=
<3><
 3
>
>   <3>sd 6:<<<3>s<3>sd <3>sd<3>
> Jan 13 18:45:15 storiq kernel: >sd <3>sd <3>s<3>sd<3>s<<3><3>s<3>sd<3=
<3<<3>sd<3>sd <3>sd<3>sd<3>sd <<3><3><<3>s<3>sd <<3>sd <3>s<3>s<3>sd <3=
>sd<3>sd <3><3><3>s<3>s<3><3><3<3><3>sd<3><3<3>s<3><3>sd<3>sd <3><3>sd<=
3><3>sd<3><3><3>s<3>sd <<3>sd 6:0:2:0: rejecting<3><3<3<3>s<3>sd<3>s<3>=
sd<3>sd <<3>s<3>sd <3<3><3>s<3>sd<3>sd<<3>sd<3>sd<3>sd <3>sd<3>s<3>sd <=
3>sd <<3>s<3>sd 6:<3>sd<3>sd <3>sd<3>sd <3>sd<<3><3><3><3>s<3>sd<<<3>sd=
<<3>sd<<3><3>sd<<3>sd<3>s<3>sd<3><3><3><3><<3>s<3>sd <3>sd<3>s<3>sd<3>s=
d<<3>s<3>sd <3><3><3>sd 6<<3>sd<3>sd<3>sd<3>sd <3><3><3>sd <3>sd<3>sd <=
3>sd <3>sd <3><3><3>sd<3>sd <3><3><3>sd <3>sd <3>sd <3><3>sd<3>s<3>s<3<=
<3>sd<3>sd<3><3>sd<<3><3<3>sd<3>s<3><3>s<3>sd<<3>sd<3>sd <<3><3><3>s<3>=
sd <3>sd 6<3>sd<<3>s<3>s<3><3>sd <3>s<3>sd<<3><<3>sd <3>sd <3>s<3<3>sd =
6<<3>s<3>sd <3>sd <3>sd <3><3<3>sd<3<3><3>s<3>s<3>s<3<3>s<3>sd <<3>s<3>=
sd <3>sd<3<3>s<3><3<3>s<3>sd<3>sd <<3>sd<3><3>s<3>s<3>s<3><3>sd <3>s<3>=
s<3>sd<3<3><3>sd <3>sd<3<3><3>sd <3>sd 6<3>s<3>sd <3>s<3>sd <3><3><3>sd=
<<3>
 s
d
>    <3>sd <3><3<3>sd<3>sd<3>sd<

This is an artifact of the linux logging system.
The '<3>' is in fact the logging priority prefix, which _should_=20
have been evaluated and dropped by the call to 'printk'.

However, printk() has this brilliant function of 'line=20
continuation', which will assume the output line is to be continued=20
when no trailing newline is found.

If you add to that the printk() might be called from different=20
contexts / thread / CPUs simultaneously, you might get a message=20
interleaving under high load (ie when lots of messages are printed=20
simultaneously).
And then the message continuation kicks in, and tries to print=20
everything in one line and doesn't interpret the leading '<3>'.
Which is what you see.

So I wouldn't classify this as a driver bug, but rather a=20
shortcoming in the linux logging system.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
