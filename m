From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 09/11] drivers/scsi: include <module.h> for modular ufshcd-pltfrm
 code
Date: Fri, 1 May 2015 09:37:47 -0400
Message-ID: <554381AB.9060205@windriver.com>
References: <1430444867-22342-1-git-send-email-paul.gortmaker@windriver.com>	 <1430444867-22342-10-git-send-email-paul.gortmaker@windriver.com> <1430447747.4545.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430447747.4545.3.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15-04-30 10:35 PM, James Bottomley wrote:
> On Thu, 2015-04-30 at 21:47 -0400, Paul Gortmaker wrote:
>> This file is built off of a tristate Kconfig option and also contains
>> modular function calls so it should explicitly include module.h to
>> avoid compile breakage during header shuffles done in the future.
> 
> I don't understand your logic.  The ufs code made a design choice to
> consolidate most headers for the hcd code in a local include (ufshcd.h),
> which includes module.h, so why would they explicitly need it here as
> well?  And if we follow your logic, why wouldn't they also need to
> duplicate everything else (like the scsi includes)?

In my original build testing this file failed to compile once the
modular code was moved from init.h to module.h as per the description
in the 0/11.

Perhaps since that testing something else has changed.  I will drop this
patch and retest and if it no longer fails, then great.

Paul.
--

> 
> James
> 
> 
