From: Rajat Jain <rajatja@google.com>
Subject: Re: [RESEND PATCH v1 1/2] trace: events: scsi: Add tag in SCSI trace events
Date: Mon, 16 Apr 2018 09:41:04 -0700
Message-ID: <CACK8Z6F02C2nskv7uO20fj=Ns3OsEwJ1FjaDYaE62+jfF5QZag@mail.gmail.com>
References: <4650cbf668fd4853ad98dba834141e08@SIWEX5A.sing.micron.com> <20180416112810.57a3f74b@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180416112810.57a3f74b@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Bean Huo (beanhuo)" <beanhuo@micron.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhad.com" <mingo@redhad.com>, "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 16, 2018 at 8:28 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 16 Apr 2018 14:31:49 +0000
> "Bean Huo (beanhuo)" <beanhuo@micron.com> wrote:
>
>> Print the request tag along with other information
>> while tracing a command.
>>
>> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Rajat Jain <rajatja@google.com>

>> ---
>
> I don't see any issue with the tracing part.
>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>
> Others need to check the content.
>
> -- Steve
