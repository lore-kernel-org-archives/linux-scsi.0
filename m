From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 31/31] xen/scsifront: Remove code that zeroes
 driver-private command data
Date: Wed, 24 May 2017 09:02:54 +0200
Message-ID: <10eedc1d-a5cf-d4fd-e470-172631f07645@suse.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-32-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-32-bart.vanassche@sandisk.com>
Content-Language: de-DE
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, xen-devel@lists.xenproject.org
List-Id: linux-scsi@vger.kernel.org

On 24/05/17 02:34, Bart Van Assche wrote:
> Since the SCSI core zeroes driver-private command data, remove
> that code from the xen-scsifront driver.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: xen-devel@lists.xenproject.org

Reviewed-by: Juergen Gross <jgross@suse.com>

Thanks,

Juergen
