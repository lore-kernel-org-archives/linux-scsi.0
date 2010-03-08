From: Gal Rosen <galr@storwize.com>
Subject: Re: [PATCH] SCSI: Synchronization issue while deleting vport
Date: Mon, 08 Mar 2010 10:05:25 +0200
Message-ID: <1268035525.2229.12.camel@galr-linux>
References: <1264061732.31083.51.camel@galr-linux>
	 <4B5A5859.1010006@emulex.com> <1264317616.17255.4.camel@galr-linux>
	 <4B5DBA51.9070500@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.storwize.com ([217.163.48.114]:42414 "EHLO
	barracuda.storwize.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752637Ab0CHIRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 03:17:13 -0500
Received: from swdc2.storwiz.com ([10.10.10.11]) by barracuda.storwize.com with ESMTP id HNjyckqb0c3NOAKf for <linux-scsi@vger.kernel.org>; Mon, 08 Mar 2010 10:16:31 +0200 (IST)
In-Reply-To: <4B5DBA51.9070500@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello James,

Do you know why the patch still not included even in scsi-rc-fixes-2.6 ?

Can you push it ?

Thanks,
Gal.

On Mon, 2010-01-25 at 10:35 -0500, James Smart wrote:
> James B controls the merge into upstream.  He will most likely include the 
> patch in scsi-rc-fixes-2.6, which will merge into one of the 2.6.33-rc? phases.
> 
> I assume the process, to get it into an already released kernel rev, is to 
> petition the 2.6.<rev>-stable tree maintainer (usually GregKH) to pick it up. 
>   You do need to be careful, as some changes are dependent on other things 
> that may have changed since that kernel revision. However, I don't think this 
> change would have that problem.
> 
> -- james s
> 
> 
> 
> Gal Rosen wrote:
> > James,
> > 
> > What is the process until it will enter to the code ?
> > and for what version 2.6.26 or 2.6.33 ?
> > 
> > Thanks,
> > Gal.
> > On Fri, 2010-01-22 at 21:00 -0500, James Smart wrote:
> >> Gal,
> >>
> >> Thanks for correcting this issue.  Patch looks good.
> >>
> >> Signed-off-by: James Smart <james.smart@emulex.com>
> >>
> >>
> >>
> >> Gal Rosen wrote:
> >>> Hi,
> >>>
> >>> Attach proposed patch for the PROBLEM: Synchronization issue in
> >>> scsi_transport_fc.
> >>>
> >>> Gal Rosen.
> >>>
> > 

