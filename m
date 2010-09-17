From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: Signal that our SATL supports WRITE SAME(16)
 with UNMAP
Date: Fri, 17 Sep 2010 02:13:30 -0400
Message-ID: <4C93070A.4060003@pobox.com>
References: <yq1vd6eqiih.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1vd6eqiih.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/10/2010 01:23 AM, Martin K. Petersen wrote:
>
> Until now identifying that a device supports WRITE SAME(16) with the
> UNMAP bit set has been black magic.  Implement support for the SBC-3
> Thin Provisioning VPD page and set the TPWS bit.
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>

applied


