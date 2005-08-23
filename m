From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 08:27:51 +0200
Message-ID: <430AC1E7.4090408@suse.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:5765 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750772AbVHWG15 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 02:27:57 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
> - There are some real challenges in supporting a udev-named boot
>   device. For the most part, it's a distro issue, which is becoming
>   better. PS: for $10, name a 2.6 distro that uses udev out
>   of the box for disk names and its installation. For $10 more,=20
>   can it install/boot from one?
Hmm. You are correct in that appearently there _is_ a large education
effort required.
SLES9 uses udev for installation and booting per default, and this work=
s
with even the horribly old version we're having there.

> - Some of these vendors come from large disk farms, and in several
>   cases, the disk farms change frequently. Thus, they must flush
>   and regenerate their udev configurations on each change. Not a
>   fun process.
Not really. You normally shouldn't have to redo the udev configuration
as your vendor/distributor will have provided you with one which works
out of the box. Of course, you'll have to initiate a rescan of the SAN
topology, but udev is the least of the problems you're facing then.

> - Most could care less about, or don't understand, the technical
>   justifications for the new 2.6 behaviors. Thus, they push their
>   vendors for same-style behaviors as 2.4 regardless of the 2.6
>   stance.
Oh, how true. I heartily agree with you on this one.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
