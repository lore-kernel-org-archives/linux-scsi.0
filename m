From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RESEND PATCH v1 1/2] trace: events: scsi: Add tag in SCSI
 trace events
Date: Mon, 16 Apr 2018 17:24:47 -0400
Message-ID: <20180416172447.5166f854@gandalf.local.home>
References: <4650cbf668fd4853ad98dba834141e08@SIWEX5A.sing.micron.com>
        <bee7c8b15b7cec3d4b1442f414e766539fac2491.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bee7c8b15b7cec3d4b1442f414e766539fac2491.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhad.com" <mingo@redhad.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "rajatja@google.com" <rajatja@google.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Apr 2018 20:49:12 +0000
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> Which tools process these strings? Has it been verified whether or not
> the tools that process these strings still work fine with this patch
> applied?

Ideally, tools shouldn't process trace event strings, but I'm sure some
do. :-/

Getting libtraceevent out as a library is a high priority of mine, and
hopefully I should get something out in a couple of months.

Ideally, tools should parse the raw data and then new fields will not
affect them.

-- Steve
