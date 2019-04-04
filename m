From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: correcting incorrect peripheral device type 0x0
Date: Thu, 4 Apr 2019 00:04:26 -0400
Message-ID: <ed1cb693-6335-f891-6905-1dda1c5ef5c3@interlog.com>
References: <ab8d589f-db76-9a95-1b55-3e906ad89487@free.fr>
 <yq1zhp6satq.fsf@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zhp6satq.fsf@oracle.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Avri Altman <avri.altman@wdc.com>, Alim Akhtar <alim.akhtar@samsung.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2019-04-03 11:34 p.m., Martin K. Petersen wrote:
> 
> Marc,
> 
>> scsi 0:0:0:49488: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c150hN
> 
>               ^^^^^ Where do these crazy LUN numbers come from? That
>               looks like something which needs fixing...
> 

sam6r04.pdf  chapter 4.7.7.5.1  followed by Linux trying to show a byte string
as an integer. But you knew that, didn't you ??
