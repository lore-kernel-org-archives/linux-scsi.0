From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Date: Wed, 28 Jan 2004 09:53:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128095341.A5242@beaverton.ibm.com>
References: <20040127003244.GM23308@serve.riede.org> <20040128033041.GY23308@serve.riede.org> <20040128084142.A4835@beaverton.ibm.com> <20040128173609.GE23308@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:10899 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S266011AbUA1Ryy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 12:54:54 -0500
Content-Disposition: inline
In-Reply-To: <20040128173609.GE23308@serve.riede.org>; from wrlk@riede.org on Wed, Jan 28, 2004 at 12:36:09PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Jan 28, 2004 at 12:36:09PM -0500, Willem Riede wrote:
> On 2004.01.28 11:41, Patrick Mansfield wrote:

> > Do you know if the single lun code is for performance, or because of
> > hardware limitations - that is we don't want a disc change between IO, or
> > does the device just fail?
> 
> In the case of the NEC PD/CD, it is a hardware limitation. You can only
> have one disc inserted at a time, either CD or PD. Mixing IO will fail
> for the absent media type.

BTW what is PD?

So there is one physical drive that can hold one disc, and it can only use
the LUN associated with the disc that is currently in the drive; and reading
or accessing the wrong LUN will always fail?

We don't need single_lun code for that, we can just let the IO fail, right?

I assume there are other single_lun devices that automatically change discs.

-- Patrick Mansfield
