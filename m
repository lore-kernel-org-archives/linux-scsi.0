From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 9/14] sas-class: sas_expander.c Expander discovery
 and configuration
Date: Fri, 09 Sep 2005 16:11:49 -0400
Message-ID: <4321EC85.6080808@adaptec.com>
References: <4321E553.6040001@adaptec.com> <29495f1d050909130525f13c7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030442AbVIIUL6@vger.kernel.org>
In-Reply-To: <29495f1d050909130525f13c7a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: nish.aravamudan@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/09/05 16:05, Nish Aravamudan wrote:
> On 9/9/05, Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> 
>>Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>
> 
> 
> <snip>
> 
> 
>>--- linux-2.6.13-orig/drivers/scsi/sas-class/sas_expander.c     1969-12-31 19:00:00.000000000 -0500
>>+++ linux-2.6.13/drivers/scsi/sas-class/sas_expander.c  2005-09-09 11:14:29.000000000 -0400
> 
> 
> <snip>
> 
> +static int sas_ex_general(struct domain_device *dev)
> 
> <snip>
> 
> +                       set_current_state(TASK_INTERRUPTIBLE);
> +                       schedule_timeout(5*HZ);
> 
> Can you use msleep_interruptible() here? I don't see wait-queues in
> the immediate vicinity. If not, and you're going for the normal -mm
> route (and from there to mainline), can you use
> schedule_timeout_interruptible(), please?

Yes, sure.  I don't see why not.

	Luben
