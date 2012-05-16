From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: qla2xxx Target Infrastructure Patches Posted on linux-scsi.
Date: Wed, 16 May 2012 16:22:46 -0700
Message-ID: <1337210566.32217.82.camel@haakon2.linux-iscsi.org>
References: <alpine.WNT.2.00.1205151701580.6000@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.WNT.2.00.1205151701580.6000@N5102REMCQXM4BS.qlogic.org>
Sender: target-devel-owner@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, target-devel@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-05-15 at 17:08 -0400, Chad Dupuis wrote:
> Hi Nicolas,
> 
> I should have CC'd the target-devel list on our latest qla2xxx posting but
> we've officially posted the patches for the qla2xxx target infrastructure
> to linux-scsi:
> 
> http://marc.info/?l=linux-scsi&m=133710840431190&w=2
> http://marc.info/?l=linux-scsi&m=133710843331208&w=2
> 

Hi Chad,

Thanks alot for the extra note to target-devel here.  ;)

Now that the tcm_qla2xxx patches are outstanding for-3.5 to linux-scsi,
I'll need to drop target-pending/qla-target-merge from for-next-merge in
order to avoid conflicts within linux-next..

James (Cc'ed) do you have an ETA for when we can expect Qlogic's
official series to be added into scsi.git/for-next..?

Thanks!

--nab
