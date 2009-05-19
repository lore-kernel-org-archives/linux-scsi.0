From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 11/13] scsi_debug: Add support for physical block exponent
 and alignment
Date: Tue, 19 May 2009 11:11:00 -0400
Message-ID: <4A12CC04.7080805@interlog.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-12-git-send-email-martin.petersen@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-12-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> From: Martin K. Petersen <martin.petersen@oracle.com>
> 
> This patch adds support for setting the physical block exponent and
> lowest aligned LBA in the READ CAPACITY(16) response.
> 
> The B0 VPD page is adjusted accordingly.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

