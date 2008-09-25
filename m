From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 22:18:16 -0700
Message-ID: <1222319896.3602.5.camel@localhost.localdomain>
References: <4C94DE2070B172459E4F1EE14BD2364E01F27D20@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60924 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbYIYFSi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 01:18:38 -0400
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F27D20@HQ-EXCH-5.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>

On Wed, 2008-09-24 at 21:09 -0700, Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains document of brocade specific sysfs interface. It is
> created using 2.6.27-rc7 kernel.
> 
> Signed-off-by: Jing Huang <huangj@brocade.com>
> ---
>  Documentation/ABI/testing/sysfs-devices-bfa |  600
> ++++++++++++++++++++++++++++
>  1 files changed, 600 insertions(+)
> 
> diff -urpN orig/Documentation/ABI/testing/sysfs-devices-bfa
> patch/Documentation/ABI/testing/sysfs-devices-bfa
> --- orig/Documentation/ABI/testing/sysfs-devices-bfa	1969-12-31
> 16:00:00.000000000 -0800
> +++ patch/Documentation/ABI/testing/sysfs-devices-bfa	2008-09-24
> 12:08:25.000000000 -0700
> @@ -0,0 +1,600 @@
> +What:		/sys/devices/<Brocade HBA PCI path>/bfa
> +Date:		July 2008
> +Contact:	Jing Huang <huangj@brocade.com>
> +Description:
> +		The /sys/devices/<Brocade HBA device path>/bfa will
> contain
> +		files and subdirectories to display internal states and
> +		statistics of Brocade HBA. It also provides a
> configuration and
> +		management interface for each HBA instance.

This is completely the wrong thing to do.  The driver needs to bind to
the Fibre Channel transport class which provides all of these features
in a large measure through infrastructure shareable with the other FC
drivers.  Any other pieces that are brocade specific rather than FC
general can go in host attributes in the same way as the rest of the FC
drivers do it.

James


