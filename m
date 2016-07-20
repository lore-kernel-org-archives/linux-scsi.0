From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2 3/3] xen-scsiback: Pass a failure indication as a
 constant
Date: Wed, 20 Jul 2016 13:44:37 +0200
Message-ID: <a295159a-b292-fdbd-6aac-5b37b49f094b@suse.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <59e51c7d-f7bb-c55f-d2fe-06dccfef6a99@users.sourceforge.net>
 <87e55a72-71ad-d0a1-b936-12565bbc6508@users.sourceforge.net>
 <fb5824ad-fb09-e471-7dc4-3e32564cc334@suse.com>
 <8806e9cb-4200-8154-7914-6735805dfbe0@users.sourceforge.net>
 <83b0b1e2-900b-eefc-160b-7d837730571c@suse.com>
 <18256bfc-c6f9-8802-8d7d-55766f0b3624@users.sourceforge.net>
 <85b948e0-bf37-dff0-6792-77b5dacef9a0@suse.com>
 <6863b12b-9095-aaf3-6140-80968e0071e2@users.sourceforge.net>
 <b025aa24-63c9-4b2e-5035-9da278f968e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbcGTLoj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2016 07:44:39 -0400
In-Reply-To: <b025aa24-63c9-4b2e-5035-9da278f968e5@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

On 20/07/16 13:36, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 20 Jul 2016 13:12:33 +0200
> 
> Pass the constant "FAILED" in a function call directly instead of
> using an intialisation for a local variable.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Even if already given, here it is again:

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
