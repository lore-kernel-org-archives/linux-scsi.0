From: Doug Ledford <dledford@redhat.com>
Subject: Re: [HELP] qla2200 driver over 4G memory
Date: Thu, 20 Jun 2002 14:18:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620141813.B9181@redhat.com>
References: <20020619190228S.miyoshi@hpc.bs1.fc.nec.co.jp> <20020619095747.M20569@hpti.com> <20020620192038J.miyoshi@hpc.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020620192038J.miyoshi@hpc.bs1.fc.nec.co.jp>; from miyoshi@hpc.bs1.fc.nec.co.jp on Thu, Jun 20, 2002 at 07:20:38PM +0900
List-Id: linux-scsi@vger.kernel.org
To: miyoshi@hpc.bs1.fc.nec.co.jp
Cc: ctierney@hpti.com, linux-scsi@vger.kernel.org

On Thu, Jun 20, 2002 at 07:20:38PM +0900, miyoshi@hpc.bs1.fc.nec.co.jp wrote:
> 
> Hi, 
> 
> Thanks for your reply.
> 
> I enabled "4GB > addressing" on HBA BIOS but it still destroys
> wrap-around memory area...

Try splitting the sg segment up into a segment that goes up to the 
boundary and a different segment that starts after the boundary and see if 
that solves the problem.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
