From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [HELP] qla2200 driver over 4G memory
Date: Thu, 20 Jun 2002 11:46:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0206201145290.31972-100000@beppo>
References: <20020620141813.B9181@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020620141813.B9181@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: miyoshi@hpc.bs1.fc.nec.co.jp, ctierney@hpti.com, linux-scsi@vger.kernel.org



Hah. The qlogic documentation is clear- you can't span 4GB segments when you
use 64 bit SCSI requests.

On Thu, 20 Jun 2002, Doug Ledford wrote:

> On Thu, Jun 20, 2002 at 07:20:38PM +0900, miyoshi@hpc.bs1.fc.nec.co.jp wrote:
> > 
> > Hi, 
> > 
> > Thanks for your reply.
> > 
> > I enabled "4GB > addressing" on HBA BIOS but it still destroys
> > wrap-around memory area...
> 
> Try splitting the sg segment up into a segment that goes up to the 
> boundary and a different segment that starts after the boundary and see if 
> that solves the problem.
> 
> -- 
>   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
>          Red Hat, Inc. 
>          1801 Varsity Dr.
>          Raleigh, NC 27606
>   
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

