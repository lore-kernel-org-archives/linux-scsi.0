From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: spin up + down disk, lk 2.4.32
Date: Wed, 07 Dec 2005 08:57:55 -0500
Message-ID: <4396EA63.2040009@pobox.com>
References: <4396D764.6020905@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4396D764.6020905@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> I was asked recently to port the START STOP UNIT
> SCSI command in libata back to lk 2.4.32 .
> 
> Changelog:
>   - add START STOP UNIT SCSI command to libata
>     allowing SATA disks to be spun down and up
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

It's already backported...

	Jeff



