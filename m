From: Tejun Heo <htejun@gmail.com>
Subject: Re: ATA Pass-Through support
Date: Sat, 4 Mar 2006 03:39:40 +0900
Message-ID: <20060303183940.GA31100@htj.dyndns.org>
References: <DF9C50EF9E8CDA45A06FE8735C68F85E5692E5@earthex2.power.com> <440736A3.8090207@pobox.com> <440873C5.8050403@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <440873C5.8050403@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Quat Le <Quat.Le@dothill.com>, "Moore, Eric" <Eric.Moore@lsil.com>, dougg@torque.net, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 03, 2006 at 10:50:13AM -0600, Brian King wrote:
> Jeff Garzik wrote:
> >Quat Le wrote:
> >>Does anyone know of any SAS HBA vendor whose driver either uses libata
> >>or supports SATA Pass-Through SCSI commands in their own layer? 
> >
> >Brian King, maintainer of the ipr driver, has posted patches which 
> >integrate libata SATA support into his driver.  Merging those is on my 
> >todo list, though I'm currently waiting on Tejun Heo's error handling 
> >work before tackling that (and NCQ and hotplug...).
> 
> Tejen,
> 
> Is there anything I can do to help with the error handling work Jeff
> is referring to?
> 

Hello, Brian.

The EH work is in the process of being merged into libata-dev
#upstream branch.  The merge process has slowed down a bit lately due
to bug fixes for 2.6.16 but it's still progressing pretty fast.  I
think/hope whole EH stuff can be merged during 2.6.17 process or
post-2.6.17 #upstream.  It shouldn't take too long.  We're just two or
three patchsets away (and all changes are living in my repository
happily although they are a bit rough).  So, please give it a few more
weeks.  We will be there.

Thanks.

-- 
tejun
