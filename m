From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 18:46:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015224602.GJ4391@redhat.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015202450.GC1049@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015202450.GC1049@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Oct 15, 2002 at 01:24:50PM -0700, Mike Anderson wrote:
> Style question below.
> 
> Doug Ledford [dledford@redhat.com] wrote:
> > @@ -481,7 +482,8 @@
> >      eh_host_reset_handler : ips_eh_reset, \
> >      abort : NULL,                         \
> >      reset : NULL,                         \
> > -    slave_attach : NULL,                  \
> > +    slave_attach : ips_slave_attach,      \
> > +    slave_detach : NULL,                  \
> >      bios_param : ips_biosparam,           \
> >      can_queue : 0,                        \
> >      this_id: -1,                          \
> 
> Can we stop setting struct members to NULL. If we later change the
> interface it makes the patch just that much larger. 

Sure, I don't care.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
