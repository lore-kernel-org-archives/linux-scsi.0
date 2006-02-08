From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [REPOST][PATCH] FC transport : Avoid device offline cases by
 stalling aborts until device unblocked
Date: Wed, 08 Feb 2006 19:37:33 +0100
Message-ID: <43EA3A6D.5060703@s5r6.in-berlin.de>
References: <43E8B19F.8050006@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38294 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030436AbWBHSce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 13:32:34 -0500
In-Reply-To: <43E8B19F.8050006@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Smart wrote:
> This moves the eh_timed_out functionality from the scsi_host_template
> to the transport_template.

Please take care to choose a proper Subject when posting patches like 
this. The patch changes the mid-low API and behaviour of the core, i.e. 
it concerns all transports.
-- 
Stefan Richter
-=====-=-==- --=- -=---
http://arcgraph.de/sr/

