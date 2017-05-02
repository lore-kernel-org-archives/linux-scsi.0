From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] iSCSI-target: Fine-tuning for some function
 implementations
Date: Mon, 01 May 2017 20:34:11 -0700
Message-ID: <1493696051.23202.0.camel@haakon3.risingtidesystems.com>
References: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Sender: target-devel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Varun Prakash <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

Hi Markus,

Apologies for the extended delayed response.

On Sun, 2017-04-09 at 16:20 +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 9 Apr 2017 16:11:23 +0200
> 
> A few update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (3):
>   Use kcalloc() in iscsit_allocate_iovecs()
>   Delete error messages for failed memory allocations
>   Improve size determinations in four functions
> 
>  drivers/target/iscsi/iscsi_target.c | 50 +++++++++++--------------------------
>  1 file changed, 15 insertions(+), 35 deletions(-)
> 

Applied.

Thank you.
