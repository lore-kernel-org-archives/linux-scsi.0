From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Wed, 27 Feb 2008 09:26:47 -0500
Message-ID: <47C57327.6070901@cybernetics.com>
References: <20080226174314.GA30767@skl-net.de> <47C49B99.1060707@nets.rwth-aachen.de> <20080227101154.GD30767@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:2645 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYB0O0w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 09:26:52 -0500
In-Reply-To: <20080227101154.GD30767@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>, adam radford <aradford@gmail.com>, =?ISO-8859-1?Q?Johannes_W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Andre Noll wrote:
> Thanks, this helped a lot. However, there does not seem to be a way
> to make the system more responsive, which is really the problem we
> are experiencing.
>
> Andre
>   
This is not 3ware-specific, but kernel 2.6.24 has new per-device write
throttling that might help with the responsiveness issue:

http://kernelnewbies.org/LinuxChanges#head-92340ffcec39e7c2a09fd933243fb18eda57f1b4
http://lwn.net/Articles/245600/

Also, check to see if the 3ware controller has a background initialize
or verify in progress, since that will obviously slow things down until
it is complete.

Tony

