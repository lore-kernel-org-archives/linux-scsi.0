From: Steven Dake <sdake@mvista.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 15:47:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB8788D.4030009@mvista.com>
References: <3DB7436E.9060100@mvista.com> <20021024223603.GF1563@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Thanks for pointing that out.  I fixed this once but must have used the 
wrong set of code
when starting this patch.  I'll fix.

Thanks again!
-steve

Mike Anderson wrote:

>Steven Dake [sdake@mvista.com] wrote:
>  
>
>>+static char scsi_hotswap_insert_by_scsi_id_usage[] = {
>>+	"Usage: echo \"[host] [channel] [lun] [id]\" > insert_by_scsi_id\n"
>>+};
>>+
>>    
>>
>
>Why is the interface lun id istead of id lun.
>The same for lun wwn instead of wwn lun.
>
>-andmike
>--
>Michael Anderson
>andmike@us.ibm.com
>
>
>
>  
>

