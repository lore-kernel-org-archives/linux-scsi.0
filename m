From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] qla2xxx: Properly set the tagging for commands.
Date: Fri, 19 Jul 2013 08:41:00 -0700
Message-ID: <20130719154100.GB22704@kroah.com>
References: <1373654871-29081-1-git-send-email-saurav.kashyap@qlogic.com>
 <1373654871-29081-3-git-send-email-saurav.kashyap@qlogic.com>
 <F5D084D6342F9B479C34599BB0A03E4D353A79E5@AVMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F5D084D6342F9B479C34599BB0A03E4D353A79E5@AVMB1.qlogic.org>
Sender: stable-owner@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 19, 2013 at 09:16:51AM +0000, Saurav Kashyap wrote:
> This should go to stable also, added in to list. This fixes a BZ https://bugzilla.kernel.org/show_bug.cgi?id=59601
> 
> Thanks,
> ~Saurav
> 
> 
> -----Original Message-----
> From: Saurav Kashyap [mailto:saurav.kashyap@qlogic.com]
> Sent: Saturday, July 13, 2013 12:18 AM
> To: jbottomley@parallels.com
> Cc: Giridhar Malavali; Saurav Kashyap; Andrew Vasquez; linux-scsi
> Subject: [PATCH 2/2] qla2xxx: Properly set the tagging for commands.
> 
> Reported-by: Jack Hill <jackhill@jackhill.us>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
