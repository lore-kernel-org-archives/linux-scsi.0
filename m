From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi/lpfc/lpfc_sli.c: Use dma_zalloc_coherent
Date: Tue, 20 Nov 2018 13:52:32 -0800
Message-ID: <34556d50-562b-43b2-873f-ba68056e5af5@broadcom.com>
References: <5bf1797b.1c69fb81.2368c.1ccc@mx.google.com>
 <16c3b882-6e0e-b712-b4d6-78f68172da65@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16c3b882-6e0e-b712-b4d6-78f68172da65@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 11/20/2018 1:40 AM, John Garry wrote:
>
> please ensure that you maintain alignment with opening brackets 

I don't think this is a requirement.  From the rules I've read 
preference is tabs-only indentation.  Spacing (less than a tab), after 
tabs, for open brace alignment is allowed, thus is coder's choice.

-- james
