From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: What factors limit the SCSI I/O request size?
Date: Wed, 19 May 2004 13:30:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF6F1CA3C2.88C29D01-ON85256E99.0070455A-88256E99.0070B22C@us.ibm.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAtCTpDJFaLE2uBc3buWekQgEAAAAA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:16858 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264531AbUESUbD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 16:31:03 -0400
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAtCTpDJFaLE2uBc3buWekQgEAAAAA@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

>By tuning sg_table_size
>and max_sectors setting in scsi_host temple following was the
>SCSI I/O request size being sent per command.
>
>Sg_table_size            max_sectors          SCSI I/O size
>   64                       256                   128k
>  128                       256                   128k
>   64                      1024                   256k
>  128                      1024                   512k
> 
> I would like to know on what basis the SCSI I/O request size per
>command is determined. What are the other factors apart from
>sg_table_size and max_sectors which can limit the I/O size?

I'm not sure what the relationship between the table and the question is; 
are you implying that there is something other than sg_table_size and 
max_sectors that affects the "SCSI I/O size" column in your experiment? 
Because the numbers there conform exactly to the limits imposed by 
sg_table_size and max_sectors (with a sector size of .5K and an sg entry 
covering one page = 4K).

