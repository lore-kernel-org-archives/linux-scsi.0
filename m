From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: [PATCH]: Fusion-MPT slowness workaround
Date: Tue, 1 Nov 2005 14:27:57 -0800
Message-ID: <200511012227.jA1MRvg01220@unix-os.sc.intel.com>
References: <91888D455306F94EBD4D168954A9457C04BE8626@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr24.intel.com ([143.183.121.16]:63679 "EHLO
	scsfmr004.sc.intel.com") by vger.kernel.org with ESMTP
	id S1751354AbVKAW2W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 17:28:22 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C04BE8626@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Moore, Eric Dean'" <Eric.Moore@lsil.com>, Martin Devera <devik@cdi.cz>, bstroesser@fujitsu-siemens.com, rupert@aquabolt.com
Cc: linux-scsi@vger.kernel.org

Moore, Eric Dean wrote on Tuesday, November 01, 2005 2:09 PM
> On Tuesday, November 01, 2005 2:39 PM, Chen, Kenneth W wrote:
> > > 
> > > I've added spin-lock to control domain validation, and 
> > > alternate controller bringup which are occuring at the same time,
> > > and causing dv to fail.  Thanks to Kenneth Chen and Bodo Stroesser.
> > 
> > With the patch, Kernel hung at boot (2.6.14 is used).
> > 
> 
> Try this patch instead.  Use it over 2.6.14, not over the
> previous post.
> 
> This patch is one that Bodo provided.  Let me know the results.


Looks OK, kernel boots and DV appears to be running correctly.

- Ken

