From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH] dpt_i2o: Add PROC_IA64 define
Date: Fri, 13 Jun 2008 10:40:35 -0400
Message-ID: <C3C13D68-8451-429F-8EB6-7C2F770DFD72@adaptec.com>
References: <4850A5A0.1040601@suse.com> <81F7F1EB-F658-40EE-ADBA-62CB85BD1F66@adaptec.com> <48528648.7070404@suse.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:46634 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896AbYFMOoD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2008 10:44:03 -0400
In-Reply-To: <48528648.7070404@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

ACK!!!

Sincerely -- Mark Salyzyn

On Jun 13, 2008, at 10:38 AM, Jeff Mahoney wrote:

> Thanks for the feedback, Mark. Round two:
>
> This fixes the following compile failure:
> drivers/scsi/dpt_i2o.c:83: error: 'PROC_IA64' undeclared here (not  
> in a function)
>
> Mark Salyzyn <Mark_Salyzyn@adaptec.com> indicated that IA64 must  
> report
> itself as PROC_INTEL, so I've changed the comment for PROC_INTEL.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>
> drivers/scsi/dpt/dptsig.h |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/drivers/scsi/dpt/dptsig.h
> +++ b/drivers/scsi/dpt/dptsig.h
> @@ -85,7 +85,7 @@ typedef unsigned int sigINT;
> /*  
> ------------------------------------------------------------------ */
> /* What type of processor the file is meant to run on. */
> /* This will let us know whether to read sigWORDs as high/low or low/ 
> high. */
> -#define PROC_INTEL      0x00    /* Intel 80x86 */
> +#define PROC_INTEL      0x00    /* Intel 80x86/ia64 */
> #define PROC_MOTOROLA   0x01    /* Motorola 68K */
> #define PROC_MIPS4000   0x02    /* MIPS RISC 4000 */
> #define PROC_ALPHA      0x03    /* DEC Alpha */
> @@ -104,6 +104,7 @@ typedef unsigned int sigINT;
> #define PROC_486        0x08    /* Intel 80486 */
> #define PROC_PENTIUM    0x10    /* Intel 586 aka P5 aka Pentium */
> #define PROC_SEXIUM    0x20    /* Intel 686 aka P6 aka Pentium Pro  
> or MMX */
> +#define PROC_IA64      0x40    /* Intel IA64 processor */
>
> /* PROC_i960: */
> #define PROC_960RX      0x01    /* Intel 80960RC/RD */
>
> --
> Jeff Mahoney
> SUSE Labs

