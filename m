From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 6/7] megaraid_sas: Do not set MPI2_TYPE_CUDA for JBOD
 FP path for FW which does not support JBOD sequence map
Date: Thu, 20 Oct 2016 07:51:28 -0400
Message-ID: <1476964288.3094.4.camel@linux.vnet.ibm.com>
References: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
         <1476954305-576-7-git-send-email-sumit.saxena@broadcom.com>
         <20161020091526.GA22193@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161020091526.GA22193@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, Sumit Saxena <sumit.saxena@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, kashyap.desai@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-10-20 at 11:15 +0200, Greg KH wrote:
> On Thu, Oct 20, 2016 at 02:05:04AM -0700, Sumit Saxena wrote:
> > CC: stable@vger.kernel.org
> > Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.com>
> > Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> I know I reject patches without any changelog text in them, hopefully
> the scsi maintainers also do...

It depends: for complex patches needing detailed explanations, yes. 
 However, this is a four line change for which the subject seems
adequately descriptive, so this particular one seems fine.

James
