From: Jean-Louis Dupond <info@dupondje.be>
Subject: Re: 2.6.24-rc5: tape drive not responding
Date: Mon, 17 Dec 2007 22:46:17 +0100
Message-ID: <4766EE29.5060706@dupondje.be>
References: <18277.52079.718004.969358@stoffel.org>	<20071217112551H.fujita.tomonori@lab.ntt.co.jp>	<20071217031510.c3d500fd.akpm@linux-foundation.org>	<18278.55130.471797.398922@stoffel.org>	<18278.58314.892734.490418@stoffel.org> <20071217134344.3f024461.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936340AbXLQVr6@vger.kernel.org>
In-Reply-To: <20071217134344.3f024461.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stoffel <john@stoffel.org>, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

http://marc.info/?l=linux-scsi&m=119770154127770&w=2

There is the patch for st.c

Andrew Morton schreef:
> On Mon, 17 Dec 2007 16:02:02 -0500
> "John Stoffel" <john@stoffel.org> wrote:
> 
>> Just to confirm, the propsed patch to st.c fixes the issue with
>> 2.6.24-rc5 as well at 2.6.24-rc5-mm1 with access to my DLT tape
>> drives.
> 
> err, what patch to st.c?
> 
> So it seems that 2.6.24 (and presumably 2.6.23?) need
> 
> 1: Alan's "initio: fix conflict when loading driver" (currently stocuk
>    in git-scsi-misc)
> 
> 2: Boaz's "initio: initio_build_scb() fix" (my name for it)
> 
> 3: The mystery st.c fix.
> 
> yes?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
