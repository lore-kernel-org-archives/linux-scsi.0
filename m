From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [TRIVIAL] copy_XX_user for sg.c - take 2
Date: Tue, 16 Jul 2002 23:25:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D34E3BA.2B2EE2AC@torque.net>
References: <20020715082116.98C2A434C@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org, wstinson@infonie.fr

Rusty Trivial Russell wrote:
> 
> [ This one is hardly trivial: it seems correct, but... Please check ]
> 
> From: (via Rusty) william stinson <wstinson@infonie.fr>
> 
>   Hi Rusty,
> 
>   here is version 2 of my sg.c patch to correct indentation to 4blanks as you pointed out (I hope I didn't miss anything).
> 
>   This proposed patch for the sg.c driver which allows user process control of SCSI devices
>           1) checks the result of copy_XX_user
>           2) returns -EFAULT in case not all data was copied
>           3) releases resources in case of failure
>           4) return value of sg_read_oxfer changed from void to int 
> in order to be able to pass back error conditions

Rusty,
This patch, together with one to disable kiobufs usage
(for Andrew Morton's direct-to-BIO changes), are in
lk 2.5.26

Doug Gilbert

