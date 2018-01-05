From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 1/2] PM / sleep: Make lock/unlock_system_sleep() available
 to kernel modules
Date: Sat, 6 Jan 2018 00:38:54 +0100
Message-ID: <CAJZ5v0iiSWRPDdVOhqLJBCLq_TG5rR_id+TZm9vTk+d1HeKNvw@mail.gmail.com>
References: <20180105171909.11839-1-bart.vanassche@wdc.com>
 <20180105171909.11839-2-bart.vanassche@wdc.com> <CAJZ5v0igct51CSp6FB=s3OZyr5fKKMxvy=T7gg2L39=r72Jtbg@mail.gmail.com>
 <1515195138.3254.26.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1515195138.3254.26.camel@wdc.com>
Sender: linux-pm-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "rafael@kernel.org" <rafael@kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "terraluna977@gmail.com" <terraluna977@gmail.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 6, 2018 at 12:32 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Sat, 2018-01-06 at 00:00 +0100, Rafael J. Wysocki wrote:
>> The changes are fine by me, but I really would prefer them to go in
>> via the PM tree which I guess means that the second patch would need
>> to go in this way too.
>
> Hello Rafael,
>
> If I can get a Tested-by from Woody and an Acked-by from Martin then I can
> do that.

That would be an ACK from Marting for the second patch.

OK
