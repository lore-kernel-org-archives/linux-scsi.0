From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 13/13] libata: Media rotation rate and form factor heuristics
Date: Fri, 15 May 2009 14:17:45 -0400
Message-ID: <4A0DB1C9.9090502@garzik.org>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-14-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-14-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> From: Martin K. Petersen <martin.petersen@oracle.com>
> 
> This patch provides new heuristics for parsing both the form factor and
> media rotation rate ATA IDENFITY words.
> 
> The reported ATA version must be 7 or greater and the device must return
> values defined as valid in the standard.  Only then are the
> characteristics reported to SCSI via the VPD B1 page.
> 
> This seems like a reasonable compromise to me considering that we have
> been shipping several kernel releases that key off the rotation rate bit
> without any version checking whatsoever.  With no complaints so far.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/ata/libata-scsi.c |   15 ++++++---------
>  include/linux/ata.h       |   28 ++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 9 deletions(-)

applied, after dropping the NONROT bit as inappropriate for 2.6.30-rc 
(which is where I applied the rest)


