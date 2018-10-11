From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/7] Neaten logging uses
Date: Thu, 11 Oct 2018 08:37:07 -0700
Message-ID: <64a18d4b6390e0c7011f440a5f1970371ce43dec.camel@perches.com>
References: <cover.1537183087.git.joe@perches.com>
         <yq1d0sh459q.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d0sh459q.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-10-10 at 21:54 -0400, Martin K. Petersen wrote:
> Joe,
> 
> > Several defects exist in the logging uses
> > 
> > o Missing KERN_<LEVEL>
> > o Unnecessary KERN_<LEVEL> uses with panic
> > o Mismatched MPT3SAS_FMT and %s: with name and __func__
> > 
> > Correct these defects and perhaps add some clarity to the logging.
> 
> Applied to 4.20/scsi-queue, thanks!

Is this branch also applied to Stephen Rothwell's -next?
