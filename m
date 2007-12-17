From: Olivier Galibert <galibert@pobox.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 17 Dec 2007 17:20:40 +0100
Message-ID: <20071217162040.GB5056@dspnet.fr.eu.org>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com> <20071217031841.f483e5ac.akpm@linux-foundation.org> <20071217130523.7e9c88bb@the-village.bc.nu> <47668A75.7040707@panasas.com> <20071217143641.760d4162@the-village.bc.nu> <1197903781.3204.4.camel@localhost.localdomain> <47669F1B.4090400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933993AbXLQQV0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47669F1B.4090400@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Filippos Papadopoulos <psybases@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 17, 2007 at 06:08:59PM +0200, Boaz Harrosh wrote:
> Below fixes a deadly typo. Might as well be included in 2.6.24

You're sure ?  scsi_for_each_sg includes a (sg)++ already...


>  		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
>  			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
>  			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
> +			++sg;
>  		}

  OG.
