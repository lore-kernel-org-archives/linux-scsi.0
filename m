From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: RE: [patch 2.5] ips queue depths
Date: Wed, 16 Oct 2002 08:01:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B0376BD@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Anderson' <andmike@us.ibm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>




> From: Mike Anderson

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
>

I'll strip all of those out.  You're right that it's just ugly,
useless code.

> -andmike

David Jeffery
