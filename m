From: Stephen Cameron <steve.cameron@hp.com>
Subject: 2.5.x Scsi_Cmnd to Scsi_Request driver fixup...
Date: Wed, 24 Jul 2002 16:51:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020724165109.A32395@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I was patching up the cpqfc driver to compile again in the 2.5.27
kernel, which was easy enough, or so I thought, until I noticed
this in scsi.c:

>  *              This function is deprecated, and drivers should be
>  *              rewritten to use Scsi_Request instead of Scsi_Cmnd.
>  */
> 
> Scsi_Cmnd *scsi_allocate_device(Scsi_Device * device, int wait, 
>                                 int interruptable)

So, I'm wondering if anyone has written anything up to help 
low-level scsi driver maintainers know what is needed to 
accomplish this rewrite?  Probably I can figure it out myself, 
(eventually) but I'm always left with a nagging feeling maybe
I missed something crucial.  A summary of the types of things
that need to change would be most helpful, if such a thing exists.

I stumbled onto this: http://gear.torque.net/scsi/scsi_stat25.html
but it doesn't seem to mention Scsi_Request, the rationale
for the change and what is expected of the low-level driver
maintainers.

Any pointers appreciated, Thanks,

-- steve

