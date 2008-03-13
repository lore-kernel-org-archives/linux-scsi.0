From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: + ipsc-fix-build-warning.patch added to -mm tree
Date: Thu, 13 Mar 2008 09:12:02 -0400
Message-ID: <A9703D7C-4D1E-4040-A7D2-DDAEF0BD101A@adaptec.com>
References: <200803122046.m2CKk3SH012462@imap1.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:51636 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYCMNMG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2008 09:12:06 -0400
In-Reply-To: <200803122046.m2CKk3SH012462@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, ipslinux@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

ACK.

IPS_BIT_START_CMD is 0x101A, poifect :-)

Sincerely -- Mark Salyzyn

On Mar 12, 2008, at 4:36 PM, akpm@linux-foundation.org wrote:
> powerpc:
>
> drivers/scsi/ips.c: In function 'ips_issue_copperhead':
> drivers/scsi/ips.c:5436: warning: large integer implicitly truncated  
> to unsigned type
>
> it doesn't seem to do outw(cpu_to_le32(...), ...) anyway.
>
> Cc: Jack Hammer <jack_hammer@adaptec.com>

Please note that Jack Hammer left Adaptec on 11/17/2006

>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: <aacraid@adaptec.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> drivers/scsi/ips.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -puN drivers/scsi/ips.c~ipsc-fix-build-warning drivers/scsi/ips.c
> --- a/drivers/scsi/ips.c~ipsc-fix-build-warning
> +++ a/drivers/scsi/ips.c
> @@ -5433,7 +5433,7 @@ ips_issue_copperhead(ips_ha_t * ha, ips_
>        }                       /* end while */
>
>        outl(cpu_to_le32(scb->scb_busaddr), ha->io_addr +  
> IPS_REG_CCSAR);
> -       outw(cpu_to_le32(IPS_BIT_START_CMD), ha->io_addr +  
> IPS_REG_CCCR);
> +       outw(cpu_to_le16(IPS_BIT_START_CMD), ha->io_addr +  
> IPS_REG_CCCR);
>
>        return (IPS_SUCCESS);
> }
