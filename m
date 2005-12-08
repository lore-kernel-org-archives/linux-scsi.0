From: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Subject: RE: [PATCH] Fix incorrect pointer in megaraid.c MODE_SENSE emulat
	ion
Date: Thu, 8 Dec 2005 08:31:50 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662C86@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751185AbVLHNcE@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: 'Mark Lord' <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,
> The SCSI megaraid drive goes to great effort to kmap
> the scatterlist buffer (if used), but then uses the
> wrong pointer when copying to it afterward.
Thank you for submitting a patch that fixes a real problem.
The patch looks perfect!

Regards,

> -----Original Message-----
> From: Mark Lord [mailto:lkml@rtr.ca] 
> Sent: Wednesday, December 07, 2005 5:47 PM
> To: Linux Kernel; linux-scsi@vger.kernel.org
> Subject: [PATCH] Fix incorrect pointer in megaraid.c 
> MODE_SENSE emulation
> 
> The SCSI megaraid drive goes to great effort to kmap
> the scatterlist buffer (if used), but then uses the
> wrong pointer when copying to it afterward.
> 
> Signed-off-by:  Mark Lord <lkml@rtr.ca>
> 
