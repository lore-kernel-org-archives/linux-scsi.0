From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date: Fri, 26 Jul 2019 12:20:10 +0200
Message-ID: <20190726102010.GB22476@kroah.com>
References: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 26, 2019 at 06:00:57AM -0400, Suganath Prabu wrote:
> Although SAS3 & SAS3.5 IT HBA controllers support
> 64-bit DMA addressing, as per hardware design,
> DMA address with all 64-bits set (0xFFFFFFFF-FFFFFFFF)
> results in a firmware fault.
> 
> Fix:
> Driver will set 63-bit DMA mask to ensure the above address
> will not be used.
> 
> Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
