From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs: Enable quirk to ignore sending WRITE_SAME command
Date: Tue, 30 Jan 2018 21:21:55 -0500
Message-ID: <yq1wozyg43g.fsf@oracle.com>
References: <1516767755-22855-1-git-send-email-asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516767755-22855-1-git-send-email-asutoshd@codeaurora.org>
        (Asutosh Das's message of "Wed, 24 Jan 2018 09:52:35 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Asutosh,

>  	/* WRITE_SAME command is not supported*/
>  	sdev->no_write_same = 1;
>  
> +	/* WRITE_SAME command is not supported*/
> +	sdev->no_write_same = 1;
> +

Uhm...

I applied this change to 4.16/scsi-fixes by hand.

-- 
Martin K. Petersen	Oracle Linux Engineering
