From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] libata SATL: WWN for device id VPD page
Date: Fri, 13 May 2011 23:28:22 -0400
Message-ID: <4DCDF6D6.3080701@interlog.com>
References: <4DCDF422.5060109@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4DCDF422.5060109@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, jgarzik@redhat.com, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11-05-13 11:16 PM, Douglas Gilbert wrote:
> libata implements a SCSI to ATA Translation Layer and
> should comply with the SAT (ANSI INCITS 431-2007) and
> SAT-2 (ANSI INCITS 465-2010).
>
> Both standards require that if an ATA device supplies
> a World Wide Name (WWN) then it should appear in the
> corresponding SCSI device identification VPD page.
>
> Changelog:
> - add NAA descriptor to the device identification VPD
> page for the addressed logical unit. ATA's WWN is
> in NAA(5) format.
>
> The attached patch is against lk 2.6.38 .
>
>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

I should have checked 2.6.39-rc9 prior to posting. Almost
the same patch as I proposed is already there.

Doug Gilbert
