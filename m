From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 5/6] scsi_debug: Update thin provisioning support
Date: Mon, 23 Aug 2010 12:37:58 -0400
Message-ID: <4C72A3E6.4050807@interlog.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com> <1282232941-9910-6-git-send-email-martin.petersen@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 10-08-19 11:49 AM, Martin K. Petersen wrote:
> The previous thin provisioning support was not very user friendly
> because it depended on all the relevant options being set on the command
> line.
>
> Implement support for the Thin Provisioning VPD page from SBC3 r24 and
> add module options for TPU (UNMAP) and TPWS (WRITE SAME (16) with UNMAP
> bit).  This allows us to have sane default and to enable thin
> provisioning with a simple tpu=1 or tpws=1 on the command line depending
> on whether we want UNMAP or WRITE SAME behavior.
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Looked ok when I took it for a spin. That was with
lk 2.6.35 .
