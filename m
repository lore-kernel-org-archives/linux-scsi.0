From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 9/12] scsi: megaraid_sas - Fix the fix for fw hang
 caused by megaraid sas application
Date: Tue, 13 Oct 2009 17:26:57 +0000
Message-ID: <1255454817.2855.211.camel@localhost.localdomain>
References: <4B6A08C587958942AA3002690DD4F8C35C5119BC@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C512405@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C6861E8@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760636AbZJMR1h@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C6861E8@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-10-06 at 14:47 -0600, Yang, Bo wrote:
> RESUBMIT:
> 
> Added the fix for FW and OS hang by using MSM.  Also add the fix for pending cmd in fw, after deleting the lds.

This is practically unintelligible as a changelog.  These logs get used
by distibutions and other people trying to determine if they need the
patch based on bug reports they're seeing

>From the patch I think what you've done is:

1. Added a lock to the skinny firmware initialisation sequence to
prevent the two stage write being non atomic if multiple instances use
it.
2. Added a flag to the driver shutdown sequence to prevent aen ioctls
being called after shutdown begins.

For the future, could we also have separate bug fixes in separate
patches, please.

Also, does this need to go to stable?

Thanks,

James
