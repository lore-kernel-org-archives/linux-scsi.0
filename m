From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] qla2xxx: Fix documentation of ql2xfdmienable module
 parameter
Date: Wed, 31 Mar 2010 09:40:23 -0700
Message-ID: <20100331094023.933bc3e5.randy.dunlap@oracle.com>
References: <87634n0xkc.fsf@tac.ki.iif.hu>
	<C7CED2FA.5FEB%giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:64240 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab0CaQmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2010 12:42:01 -0400
In-Reply-To: <C7CED2FA.5FEB%giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>, james.bottomley@suse.de
Cc: Ferenc Wagner <wferi@niif.hu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LinuxSCSI <linux-scsi@vger.kernel.org>

On Tue, 23 Mar 2010 20:20:10 -0700 Giridhar Malavali wrote:

> 
> 
> 
> On 3/23/10 10:14 AM, "Ferenc Wagner" <wferi@niif.hu> wrote:
> 
> > The default is enabled since 7e47e5ca184548341a82eeb2238ee3622c43cae1.
> > 
> > Signed-off-by: Ferenc Wagner <wferi@niif.hu>

Hi James,

What is the best way for any interested party to tell if you have merged (applied,
accepted) a patch in the scsi subsystem?

Thanks.

> > ---
> >  drivers/scsi/qla2xxx/qla_os.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> > index 46720b2..ac08397 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -69,8 +69,8 @@ static void qla2x00_free_device(scsi_qla_host_t *);
> >  int ql2xfdmienable=1;
> >  module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
> >  MODULE_PARM_DESC(ql2xfdmienable,
> > -               "Enables FDMI registratons "
> > -               "Default is 0 - no FDMI. 1 - perfom FDMI.");
> > +               "Enables FDMI registrations. "
> > +               "0 - no FDMI. Default is 1 - perform FDMI.");
> > 
> >  #define MAX_Q_DEPTH    32
> >  static int ql2xmaxqdepth = MAX_Q_DEPTH;
> > --
> 
> Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>


---
~Randy
