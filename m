From: Jody McIntyre <scjody@modernduck.com>
Subject: Re: 2.6.15-rc2: oops after abortion of SCSI inquiry
Date: Mon, 28 Nov 2005 17:34:11 -0500
Message-ID: <20051128223411.GP20781@conscoop.ottawa.on.ca>
References: <438832A0.7000309@s5r6.in-berlin.de> <20051128190457.GH20781@conscoop.ottawa.on.ca> <438B6106.3070709@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [205.233.219.253] ([205.233.219.253]:28346 "EHLO
	conifer.conscoop.ottawa.on.ca") by vger.kernel.org with ESMTP
	id S932259AbVK1Wfk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 17:35:40 -0500
Content-Disposition: inline
In-Reply-To: <438B6106.3070709@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Mon, Nov 28, 2005 at 08:56:54PM +0100, Stefan Richter wrote:

> I am quite certain that when I first saw the oops I had all post-2.6.14 
> ieee1394 updates applied, i.e. the sbp2_command_orb_lock fix too. It 
> happened the same way with and without these ieee1394 updates.

Darn.  Well, can you produce a .s file following the steps in
Documentation/oops-tracing.txt and try to track down exactly what is
happening?  If not, send me the .s and I'll see if I have time to look
into it.  Be sure the .s matches your configuration and patches at the
time of the oops :)

How reproducible is this anyway?

Cheers,
Jody

> -- 
> Stefan Richter
> -=====-=-=-= =-== ===--
> http://arcgraph.de/sr/
> 
> 
> -------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
> for problems?  Stop!  Download the new AJAX search engine that makes
> searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
> http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
> _______________________________________________
> mailing list linux1394-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux1394-devel

-- 
