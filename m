From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: 2.6.3 oops at kobject_unregister, alsa & aic7xxx
Date: Tue, 24 Feb 2004 10:56:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2098950000.1077645372@aslan.btc.adaptec.com>
References: <1077546633.362.28.camel@boxen>	 <20040223160716.799195d0.akpm@osdl.org> <1077602725.3172.19.camel@opiate>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:31954 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262330AbUBXR4P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 12:56:15 -0500
In-Reply-To: <1077602725.3172.19.camel@opiate>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Eric Kerin <eric@bootseg.com>, Alexander Nyberg <alexn@telia.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> I stumbled up this in early January.  I posted a patch to linux-scsi,
> but it dosn't seem to be merged at this point.  This problem will also
> occur with the aic79xx driver.

After your report, I integrated a similar fix into the drivers posted
from my site back in January.

--
Justin

