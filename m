From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 16:24:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015202406.GF4391@redhat.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015201022.GB1049@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015201022.GB1049@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Oct 15, 2002 at 01:10:22PM -0700, Mike Anderson wrote:
> I never seen the mid layer handle device starvation correctly. It might
> be because in scsi_queue_next_request we do this:
> 
> /*
>  * Just hit the requeue function for the queue.
>  */
>   q->request_fn(q);
> 
> before we check for starved.

Don't pay too much attention to the junk that's there now...

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
