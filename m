From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] lpfc: nvmet_fc: fix format string
Date: Sat, 20 May 2017 17:43:34 -0700
Message-ID: <1495327414.2093.8.camel@perches.com>
References: <20170519080447.1043039-1-arnd@arndb.de>
         <1495276127.27714.4.camel@perches.com>
         <CAK8P3a37qj9szwsmksxFr_pWXK8LLzTG+4_mJ7t9WB76pO6A2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:59524 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751830AbdEUAnw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 May 2017 20:43:52 -0400
In-Reply-To: <CAK8P3a37qj9szwsmksxFr_pWXK8LLzTG+4_mJ7t9WB76pO6A2A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sat, 2017-05-20 at 21:10 +0200, Arnd Bergmann wrote:
> On Sat, May 20, 2017 at 12:28 PM, Joe Perches <joe@perches.com> wrote:
> > On Fri, 2017-05-19 at 10:04 +0200, Arnd Bergmann wrote:
> > > The lpfc_nvmeio_data() tracing helper always takes a format string and
> > > three additional arguments.
> > 
> > No it doesn't.  It takes a format and arguments.
> > 
> > I don't disagree with the patch, just the characterization
> > of the lpfc_mvmeio_data call in the commit message.
> 
> I think my description is correct, it's just not obvious from
> reading the code until you also look at the lpfc_debugfs_nvme_trc
> prototype:

OK, but more that's a mismatch between a function and its
arguments and a different called function within it.
