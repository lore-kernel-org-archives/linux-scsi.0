From: Ben Collins <bcollins@debian.org>
Subject: Re: [BK PATCH] SCSI updates for 2.6.9
Date: Tue, 19 Oct 2004 03:42:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041019074212.GB19186@phunnypharm.org>
References: <1098137016.2011.339.camel@mulgrave> <200410182341.13648.dtor_core@ameritech.net> <200410190012.28071.dtor_core@ameritech.net> <Pine.LNX.4.58.0410190009260.2287@ppc970.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.swissdisk.com ([65.207.35.130]:48285 "EHLO
	bristol.swissdisk.com") by vger.kernel.org with ESMTP
	id S268070AbUJSIv4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 04:51:56 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0410190009260.2287@ppc970.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor_core@ameritech.net>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, willy@debian.org, Linux1394-Devel <linux1394-devel@lists.sourceforge.net>

On Tue, Oct 19, 2004 at 12:13:08AM -0700, Linus Torvalds wrote:
> 
> Ben,
>  does this look ok to you?
> 
> Arguably the SCSI layer should also have proper prefixes for its constants
> - and in fact they do kind of exist as the GPCMD_xxx constants.  Oh, well.
> Regardless, the sbp2 constants do look like they want prefixing..

Looks good to me.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
WatchGuard - http://www.watchguard.com/
