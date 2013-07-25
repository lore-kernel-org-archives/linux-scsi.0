From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8][SCSI] mpt2sas: Infinite loop can occur if
 MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
Date: Thu, 25 Jul 2013 07:00:24 -0700
Message-ID: <1374760824.1952.1.camel@dabdike>
References: <20130725055945.GA29898@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130725055945.GA29898@lsi.com>
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: jejb@kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-07-25 at 11:29 +0530, Sreekanth Reddy wrote:
> Infinite loop can occur if IOCStatus is not equal to
> MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value in the while loops in functions
> _scsih_search_responding_sas_devices,
> _scsih_search_responding_raid_devices and
> _scsih_search_responding_expanders
> 
> So, Instead of checking for MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value,
> in this patch code is modified to check for IOCStatus not equals to
> MPI2_IOCSTATUS_SUCCESS to break the while loop.
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: stable@vger.kernel.org

Patches like this aren't acceptable any more: Greg will find this and
reject it from Stable.

If there's a bug in the driver, it needs to be in a separate patch set
for the fixes branch of SCSI to go upstream now rather than waiting for
the merge window.  Only patches for the fixes branch can be tagged for
stable.

James
