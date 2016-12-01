From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.8 11/37] scsi: mpt3sas: Fix secure erase premature
 termination
Date: Thu, 1 Dec 2016 08:10:39 +0100
Message-ID: <20161201071039.GA14521@kroah.com>
References: <20161130092729.623248210@linuxfoundation.org>
 <20161130092730.337406282@linuxfoundation.org>
 <yq1k2bkj4jv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1k2bkj4jv.fsf@sermon.lab.mkp.net>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Andrey Grodzovsky <andrey2805@gmail.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 30, 2016 at 11:49:56AM -0500, Martin K. Petersen wrote:
> >>>>> "Greg" == Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> Greg,
> 
> Greg> From: Andrey Grodzovsky <andrey2805@gmail.com>
> 
> Greg> commit 18f6084a989ba1b38702f9af37a2e4049a924be6 upstream.
> 
> Please also queue 7ff723ad0f87 ("scsi: mpt3sas: Unblock device after
> controller reset") which just hit Linus' tree. It's a bug fix for the
> patch above.

Now queued up, thanks.

greg k-h
