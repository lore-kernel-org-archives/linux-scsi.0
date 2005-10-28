From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 0/2] libata: MODE SELECT
Date: Fri, 28 Oct 2005 15:59:51 -0400
Message-ID: <43628337.30208@pobox.com>
References: <435B2C47.8070708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <435B2C47.8070708@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Jeff,
> Here is another shot at adding MODE SELECT to
> libata. I have used sat-r06, sbc-3 and spc-4 as
> a guide. Compliance on the ATA side has some issues:
>   - no mechanism to issue 2 or more ATA commands
>     when translating a single SCSI command [in the
>     upstream branch, there have been patches ...]
>   - relies on the dev->id array (IDENTIFY DEVICE response)
>     always being up to date. Despite assurances I cannot
>     see how that is the case when multiple hosts
>     (initiators) can access a SATA disk.
> 
> This patch is broken into two parts and is against
> libata-dev's upstream branch:
>   1) strengthen MODE SENSE processing and make
>      default mode pages visible within libata-scsi.c
>   2) add MODE SELECT SCSI command support.


Thanks for splitting it up.  I'm going to mess around with the best way 
to issue multiple commands, and hold on to your patch #2 until that happens.

	Jeff


