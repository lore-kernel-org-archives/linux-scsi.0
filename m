From: Doug Ledford <dledford@redhat.com>
Subject: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 17:30:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117223051.GJ3280@redhat.com>
References: <200211172212.gAHMCp99017977@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211172212.gAHMCp99017977@leviathan.ele.uri.edu>
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 05:11:28PM -0500, Ming Zhang wrote:
> Hi, I meet a problem when port my code to 2.5.47.
> My goal is to get all scsi disk Scsi_Device pointers.

Why?  A couple people on this list have been trying to put proper object 
ref counting in place, and doing this sort of thing usually violates those 
ref counting rules, so unless you have a true valid need to do this, the 
answer is probably going to be "Don't do that".

> For 2.4.18, I can use scsi_hostlist to travel through the list and get all pointer by comparing type if TYPE_DISK. But in 2.5.47, there is no such pointer. And that scsi_host_list can not be used.
> 
> Does anyone know how to get around to this? 
> 
> Thanks in advance.
> 
> 
> 
> Best regards. 
> 
> 
> Ming Zhang
> ------------------------------
> Member of IEEE, ACM
> mingz@ele.uri.edu
> http://www.ele.uri.edu/~mingz
> 1(401)874-4859
> 
> Department of Electrical and Computer Engineering
> University of Rhode Island
> 
> 4 East Alumni Ave. Kingston, RI, 02881
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
