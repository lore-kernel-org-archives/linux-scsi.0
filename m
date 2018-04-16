From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RESEND PATCH v1 2/2] trace: events: block: Add tag in block
 trace events
Date: Mon, 16 Apr 2018 11:29:26 -0400
Message-ID: <20180416112926.7b44d03f@gandalf.local.home>
References: <64d6073b28b140cda3e5870a54e0a7bc@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <64d6073b28b140cda3e5870a54e0a7bc@SIWEX5A.sing.micron.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhad.com" <mingo@redhad.com>, "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>, "rajatja@google.com" <rajatja@google.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Apr 2018 14:33:29 +0000
"Bean Huo (beanhuo)" <beanhuo@micron.com> wrote:

> Print the request tag along with other information in block trace events
> when tracing request , and unplug type (Sync / Async).
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>

I don't see any issue with the tracing part.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Others need to check the content.

-- Steve


> ---
>  include/trace/events/block.h | 36 +++++++++++++++++++++++++-----------
>  1 file changed, 25 insertions(+), 11 deletions(-)
> 
