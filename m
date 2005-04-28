From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: latest mpt-fusion oopses
Date: Thu, 28 Apr 2005 08:55:54 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0225CC57@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:30935 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261948AbVD1O4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 10:56:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Just got into the office.  Working on reproducing.
I'll keep you updated.

Thanks,
Eric Moore
LSI Logic Corporation

On Thursday, April 28, 2005 3:21 AM, Andrew Morton wrote:
> 
> Andrew Morton <akpm@osdl.org> wrote:
> >
> > I guess I'll test this on x86 next.
> 
> It crashed, strangely.  See
> http://www.zip.com.au/~akpm/linux/patches/stuff/dsc02504.jpg.
> 
> It appears to have jumped directly to address zero from 
> handle_IRQ_event. 
> Disabling CONFIG_PM didn't help.  No shared IRQs on this box.
> 
> Config is at http://www.zip.com.au/~akpm/linux/patches/stuff/config
> 
