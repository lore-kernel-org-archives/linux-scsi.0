From: "Gibbs, Justin" <Justin_Gibbs@adaptec.com>
Subject: RE: [TRIVIAL] Missing ';' in drivers_scsi_aic7xxx_aicasm_aicasm_g
	ram.y
Date: Thu, 6 Feb 2003 00:53:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6100BCEB85F8E244959C756C04E0EDD162A3DB@otcexc01.otc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Rusty Trivial Russell' <rusty@rustcorp.com.au>, "Gibbs, Justin" <Justin_Gibbs@adaptec.com>, linux-scsi@vger.kernel.org

This has been fixed for a few months now in my sorces.
Feel free to grab them from:

http://people.FreeBSD.org/~gibbs/linux/SRC/

--
Justin

> -----Original Message-----
> From: Rusty Trivial Russell [mailto:rusty@rustcorp.com.au]
> Sent: Wednesday, February 05, 2003 8:17 PM
> To: Justin Gibbs; linux-scsi@vger.kernel.org
> Subject: [TRIVIAL] Missing ';' in
> drivers_scsi_aic7xxx_aicasm_aicasm_gram.y
> 
> 
> [ No idea if this is correct - is it? --RR ]
> From:  Thibaut VARENE <varenet@parisc-linux.org>
> 
>   I tested 2.4.20 on my ppc box and got 2 error messages on the file
>   drivers/scsi/aic7xxx/aicasm/aicasm_gram.y, complaining 
> about expected ';'.
>   
>   I corrected these with the attached patch.
>   
>   HTH,
>   
>   
>   Thibaut VARENE
>   The PA/Linux ESIEE Team
>   http://pateam.esiee.fr/
>   
>   
> 
> --- 
> trivial-2.4.21-pre4/drivers/scsi/aic7xxx/aicasm/aicasm_gram
> .y.orig	2003-02-06 13:53:52.000000000 +1100
> +++ 
> trivial-2.4.21-pre4/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y	
> 2003-02-06 13:53:52.000000000 +1100
> @@ -917,6 +917,7 @@
>  		cs->begin_addr = instruction_ptr;
>  		in_critical_section = TRUE;
>  	}
> +;
>  
>  critical_section_end:
>  	T_END_CS ';'
> @@ -931,6 +932,7 @@
>  		cs->end_addr = instruction_ptr;
>  		in_critical_section = FALSE;
>  	}
> +;
>  
>  export:
>  	{ $$ = 0; }
> -- 
>   Don't blame me: the Monkey is driving
>   File: Thibaut VARENE <varenet@parisc-linux.org>: [PATCH] 
> Missing ';' in drivers_scsi_aic7xxx_aicasm_aicasm_gram.y
> 
