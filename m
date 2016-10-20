From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 6/7] megaraid_sas: Do not set MPI2_TYPE_CUDA for JBOD
 FP path for FW which does not support JBOD sequence map
Date: Thu, 20 Oct 2016 11:15:26 +0200
Message-ID: <20161020091526.GA22193@kroah.com>
References: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
 <1476954305-576-7-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476954305-576-7-git-send-email-sumit.saxena@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 20, 2016 at 02:05:04AM -0700, Sumit Saxena wrote:
> CC: stable@vger.kernel.org
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

I know I reject patches without any changelog text in them, hopefully
the scsi maintainers also do...
