From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aacraid controller hangs if kernel uses non-default ASPM policy
Date: Fri, 11 Nov 2011 08:15:13 -0600
Message-ID: <1321020913.5161.15.camel@dabdike.int.hansenpartnership.com>
References: <4EBCEDED.7030907@parallels.com>
	 <20111111130938.GA10242@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42834 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab1KKOPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 09:15:16 -0500
In-Reply-To: <20111111130938.GA10242@srcf.ucam.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Vasily Averin <vvs@parallels.com>, linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>

On Fri, 2011-11-11 at 13:09 +0000, Matthew Garrett wrote:
> Yeah, sorry about that, it's something that was on my list to deal with. 
> Disabling ASPM entirely on aacraid really isn't a desirable outcome - 
> it'd be significantly better to identify which chipsets are broken with 
> it enabled and then only disable those.

Well, aacraid is out of production, I believe, so lets fix the hang
first (with a global disable) and we can gradually re-enable if we get
experimenters who try it with particular HW.

James



