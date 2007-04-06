From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Fri, 06 Apr 2007 08:44:54 -0500
Message-ID: <1175867094.3677.5.camel@mulgrave.il.steeleye.com>
References: <200704060221.l362LD4s025776@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1767644AbXDFNq0@vger.kernel.org>
In-Reply-To: <200704060221.l362LD4s025776@cichlid.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2007-04-05 at 19:21 -0700, Andrew Burgess wrote:
> 2.6.20.4 with your patch dies in the memcpy (as does 21-gitN)
> 
> 2.6.20.4 without your patch dies in the subsequent __free_page
> with a null pointer ref at 000...008
> 
> James should I try your posted patch? On which kernel?

Well, mine will work, but will also cover up the problem.  It looks like
the scatterlist is getting corrupted by the HBA driver somehow ... we
really need to root cause this, otherwise other things will go wrong in
strange ways.

Just to confirm, the HBA with the problem is 3w-xxxx?

James
